import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/features/search/data/datasources/search_remote_data_source_impl.dart';
import 'package:weather_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:weather_app/features/search/domain/repositories/search_repository.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source_impl.dart';
import 'package:weather_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source_impl.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/router/router.gr.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  Future<void> init(BuildContext context) async {
    getIt.registerSingleton<Dio>(Dio());
    getIt.registerSingleton<NetworkInfo>(
      NetworkInfoImpl(InternetConnectionChecker()),
    );
    getIt.registerSingleton<SearchRepository>(
      SearchRepositoryImpl(
        remoteDataSource: SearchRemoteDataSourceImpl(
          api: GeoNamesApi(getIt.get<Dio>()),
        ),
        networkInfo: getIt.get<NetworkInfo>(),
      ),
    );

    getIt.registerSingleton<SettingsBloc>(
      BlocProvider.of<SettingsBloc>(context),
    );
    getIt.registerSingleton<WeatherBloc>(
      BlocProvider.of<WeatherBloc>(context),
    );
    getIt.registerSingleton<StackRouter>(AutoRouter.of(context));

    getIt.get<SettingsBloc>().add(
          SettingsInitialized(
            SettingsRepositoryImpl(
              localDataSource: SettingsLocalDataSourceImpl(
                await SharedPreferences.getInstance(),
              ),
            ),
          ),
        );

    getIt.get<WeatherBloc>().add(
          WeatherInitialized(
            repository: WeatherRepositoryImpl(
              networkInfo: getIt.get<NetworkInfo>(),
              remoteDataSource: WeatherRemoteDataSourceImpl(
                api: OpenWeatherApi(getIt.get<Dio>()),
              ),
            ),
            settingsBloc: getIt.get<SettingsBloc>(),
          ),
        );

    await Future.wait([
      initializeDateFormatting('ru_RU'),
      getIt
          .get<SettingsBloc>()
          .stream
          .firstWhere((element) => element is SettingsSuccess)
          .then((value) {
        getIt.get<WeatherBloc>().add(const WeatherUpdateRequested());
      })
    ]);
    getIt.get<StackRouter>().replace(const HomeRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: init(context)..onError((error, stackTrace) => throw error!),
          builder: (context, snapshot) {
            return SizedBox.expand(
              child: Column(
                children: [
                  const Spacer(),
                  Text('Weather', style: Theme.of(context).textTheme.headline2),
                  const Spacer(),
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
