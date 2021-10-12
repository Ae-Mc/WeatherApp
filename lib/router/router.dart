import 'package:auto_route/auto_route.dart';
import 'package:weather_app/pages/about/about.dart';
import 'package:weather_app/pages/home/home.dart';
import 'package:weather_app/pages/settings/settings.dart';
import 'package:weather_app/pages/week_forecast/week_forecast.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: HomePage,
    ),
    AutoRoute(
      path: '/settings',
      page: SettingsPage,
    ),
    AutoRoute(
      path: '/about',
      page: AboutPage,
    ),
    AutoRoute(
      path: '/week_forecast',
      page: WeekForecastPage,
    )
  ],
)
class $AppRouter {}
