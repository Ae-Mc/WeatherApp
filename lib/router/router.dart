import 'package:auto_route/auto_route.dart';
import 'package:weather_app/pages/about/about.dart';
import 'package:weather_app/features/settings/presentation/pages/favorites_page.dart';
import 'package:weather_app/pages/home/home.dart';
import 'package:weather_app/pages/loading/loading.dart';
import 'package:weather_app/features/search/presentation/pages/search_page.dart';
import 'package:weather_app/features/settings/presentation/pages/settings_page.dart';
import 'package:weather_app/pages/week_forecast/week_forecast.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage),
    AutoRoute(page: SettingsPage),
    AutoRoute(page: AboutPage),
    AutoRoute(page: WeekForecastPage),
    AutoRoute(page: SearchPage),
    AutoRoute(page: FavoritesPage),
    AutoRoute(initial: true, page: LoadingPage)
  ],
)
class $AppRouter {}
