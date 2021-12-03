import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source_impl.dart';
import 'package:weather_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/pages/home_page.dart';
import 'package:weather_app/features/weather/presentation/widgets/custom_bottom_sheet.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'home_page_test.mocks.dart';

@GenerateMocks([WeatherRepository])
void main() async {
  await initializeDateFormatting('ru_RU');
  final SettingsBloc settingsBloc = SettingsBloc();
  final WeatherBloc weatherBloc = WeatherBloc();
  final weatherRepository = MockWeatherRepository();
  final defaultWeather =
      WeatherModel.fromJson(jsonDecode(fixture('weather.json'))).toWeather();

  when(weatherRepository.getWeather(any))
      .thenAnswer((realInvocation) async => const Left(ServerFailure(400)));

  settingsBloc.add(
    SettingsInitialized(
      SettingsRepositoryImpl(
        localDataSource: SettingsLocalDataSourceImpl(
          await SharedPreferences.getInstance(),
        ),
      ),
    ),
  );
  await settingsBloc.stream
      .firstWhere((element) => element is! SettingsInProgress);
  weatherBloc.add(
    WeatherInitialized(
      repository: weatherRepository,
      settingsBloc: settingsBloc,
    ),
  );
  await weatherBloc.stream
      .firstWhere((element) => element is! WeatherLoadInProgress);
  getIt.registerSingleton(settingsBloc);
  getIt.registerSingleton(weatherBloc);

  group('HomePage tests.', () {
    final homePage = BlocProvider.value(
      value: settingsBloc,
      child: BlocProvider.value(
        value: weatherBloc,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    group('Successful connection.', () {
      setUp(() async {
        when(weatherRepository.getWeather(any)).thenAnswer(
          (realInvocation) async => Right(defaultWeather),
        );
        weatherBloc.add(const WeatherUpdateRequested());
        await weatherBloc.stream
            .firstWhere((element) => element is! WeatherLoadInProgress);
      });

      test('Blocs initialized properly', () async {
        final settingsState = settingsBloc.state;
        final weatherState = weatherBloc.state;

        expect(settingsState, const TypeMatcher<SettingsSuccess>());
        expect(weatherState, const TypeMatcher<WeatherSuccess>());
      });

      testWidgets(
        "Test home screen base composition.",
        (WidgetTester tester) async {
          await tester.pumpWidget(homePage);
          await tester.pumpAndSettle();
          expect(weatherBloc.state, const TypeMatcher<WeatherSuccess>());

          expect(find.byType(MaterialApp), findsOneWidget);
          expect(find.byType(HomePage), findsOneWidget);
          expect(find.byType(RefreshIndicator), findsOneWidget);
          expect(find.byType(CustomBottomSheet), findsOneWidget);
          expect(find.byType(HomeBottomSheetContent), findsOneWidget);

          expect(find.text('Прогноз на неделю'), findsOneWidget);
          expect(find.text('Санкт-Петербург').evaluate(), isEmpty);
        },
      );

      testWidgets(
        "Test home screen bottom sheet swipe.",
        (WidgetTester tester) async {
          await tester.pumpWidget(homePage);
          await tester.pumpAndSettle();
          expect(weatherBloc.state, const TypeMatcher<WeatherSuccess>());

          await tester.drag(
            find.byType(CustomBottomSheet),
            const Offset(0, -10000),
          );
          await tester.pumpAndSettle();

          expect(find.text('Санкт-Петербург'), findsOneWidget);

          expect(find.text('Прогноз на неделю').evaluate(), isEmpty);
        },
      );

      testWidgets(
        "Test home screen bottom sheet swipe up and down.",
        (WidgetTester tester) async {
          await tester.pumpWidget(homePage);
          await tester.pumpAndSettle();
          expect(weatherBloc.state, const TypeMatcher<WeatherSuccess>());

          await tester.drag(
            find.byType(CustomBottomSheet),
            const Offset(0, -10000),
          );
          await tester.pumpAndSettle();
          await tester.drag(
            find.byType(CustomBottomSheet),
            const Offset(0, 10000),
          );
          await tester.pumpAndSettle();

          expect(find.text('Прогноз на неделю'), findsOneWidget);
          expect(find.text('Санкт-Петербург').evaluate(), isEmpty);
        },
      );
    });
  });
}
