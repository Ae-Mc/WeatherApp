import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:weather_app/features/settings/data/models/settings_model.dart';
import 'package:weather_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart'
    hide uninitializedErrorMessage;
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source_impl.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'weather_bloc_test.mocks.dart';

import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([InternetConnectionChecker, OpenWeatherApi])
void main() {
  final connectionChecker = MockInternetConnectionChecker();
  final openWeatherApi = MockOpenWeatherApi();

  group('WeatherBloc tests. ', () {
    late final SettingsBloc settingsBloc;
    setUp(
      () async {
        when(connectionChecker.hasConnection)
            .thenAnswer((realInvocation) async => true);
        when(openWeatherApi.weather(any, any)).thenAnswer(
          (realInvocation) async => WeatherModel.fromJson(
            jsonDecode(fixture('weather.json')),
          ),
        );
        settingsBloc = await getSettingsBloc();
      },
    );
    blocTest(
      'test bloc initialization',
      build: () => WeatherBloc(),
      act: (WeatherBloc weatherBloc) => weatherBloc.add(
        WeatherInitialized(
          repository: WeatherRepositoryImpl(
            networkInfo: NetworkInfoImpl(InternetConnectionChecker()),
            remoteDataSource: WeatherRemoteDataSourceImpl(
              api: openWeatherApi,
            ),
          ),
          settingsBloc: settingsBloc,
        ),
      ),
      wait: const Duration(milliseconds: 50),
      expect: () {
        return [
          const WeatherLoadInProgress(),
          WeatherSuccess(
            WeatherModel.fromJson(
              jsonDecode(fixture('weather.json')),
            ).toWeather(),
          ),
        ];
      },
    );

    tearDown(() {
      reset(connectionChecker);
      reset(openWeatherApi);
    });
  });
}

@GenerateMocks([SettingsLocalDataSource])
Future<SettingsBloc> getSettingsBloc() async {
  final settingsBloc = SettingsBloc();
  final settingsLocalDataSource = MockSettingsLocalDataSource();
  when(settingsLocalDataSource.getSettings()).thenAnswer(
    (realInvocation) async => SettingsModel.fromSettings(
      const Settings.defaultSettings().copyWith(
        pressureUnits: PressureUnits.hectopascal,
        speedUnits: SpeedUnits.metersPerSecond,
        temperatureUnits: TemperatureUnits.celcius,
      ),
    ),
  );
  settingsBloc.add(
    SettingsInitialized(
      SettingsRepositoryImpl(localDataSource: settingsLocalDataSource),
    ),
  );
  await settingsBloc.stream
      .firstWhere((element) => element is! SettingsInProgress);
  return settingsBloc;
}
