import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/providers/settings_provider.dart';
import 'package:weather_app/data/providers/weather_provider.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/router/router.gr.dart';
import 'package:weather_app/theme/style.dart';

final getIt = GetIt.instance;

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(),
      lazy: true,
      child: BlocProvider(
        create: (context) => WeatherBloc(),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProxyProvider<SettingsProvider, WeatherProvider>(
              create: (_) => WeatherProvider(),
              update: (_, settings, weather) {
                if (weather == null) {
                  throw ArgumentError.notNull('weather');
                }
                weather.settings = settings;
                return weather;
              },
            ),
          ],
          builder: (context, _) {
            final style = Style();
            return BlocBuilder<SettingsBloc, SettingsState>(
              buildWhen: (oldState, newState) {
                return newState is SettingsSuccess;
              },
              builder: (context, state) {
                return MaterialApp.router(
                  title: 'Weather app',
                  theme: style.lightTheme,
                  darkTheme: style.darkTheme,
                  themeMode: (state is SettingsSuccess)
                      ? state.settings.themeMode
                      : ThemeMode.dark,
                  routerDelegate: _appRouter.delegate(),
                  routeInformationParser: _appRouter.defaultRouteParser(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
