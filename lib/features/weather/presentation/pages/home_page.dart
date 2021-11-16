import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/widgets/custom_bottom_sheet.dart';
import 'package:weather_app/features/weather/presentation/widgets/my_icon_button.dart';
import 'package:weather_app/gen/assets.gen.dart';
import 'package:weather_app/router/router.gr.dart';

const settingsUnknowFailureMessage =
    'Произошла непредвиденная ошибка при получении настроек';
const weatherUnknowFailureMessage = ''
    'Произошла непредвиденная ошибка при получении погоды';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bottomSheetExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            color: Theme.of(context).colorScheme.onBackground,
            onRefresh: () {
              context.read<WeatherBloc>().add(const WeatherUpdateRequested());
              return context
                  .read<WeatherBloc>()
                  .stream
                  .firstWhere((element) => element is! WeatherLoadInProgress);
            },
            child: LayoutBuilder(
              builder: (_, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: constraints,
                  child: _header(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomSheet(
              builder: (context, expanded) => HomeBottomSheetContent(expanded),
              onStateChange: (extended) =>
                  setState(() => bottomSheetExpanded = extended),
              minHeight: 250,
              maxHeight: 450,
            ),
          ),
        ],
      ),
      drawer: const HomeDrawer(),
    );
  }

  Widget _header() {
    return Ink(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (Theme.of(context).brightness == Brightness.light
              ? Assets.images.background
              : Assets.images.darkBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: _headerContent(),
        ),
      ),
    );
  }

  Widget _headerContent() {
    return SettingsBlocBuilder(
      builder: (context, settingsState) {
        return WeatherBlocBuilder(
          builder: (context, weatherState) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const Pad(horizontal: 25, top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyIconButton(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu_rounded),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSizeAndFade(
                            sizeDuration: const Duration(milliseconds: 300),
                            fadeDuration: const Duration(milliseconds: 300),
                            child: bottomSheetExpanded
                                ? Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const Pad(top: 8, bottom: 19),
                                      child: Text(
                                        settingsState.settings.activePlace.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(width: double.infinity),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: weatherState.weather.current.temp
                                      .toStringAsFixed(1),
                                ),
                                TextSpan(
                                  text: settingsState
                                      .settings.temperatureUnits.inString,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        letterSpacing: -11.5,
                                      ),
                                ),
                              ],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedSizeAndFade(
                            sizeDuration: const Duration(milliseconds: 300),
                            fadeDuration: const Duration(milliseconds: 300),
                            child: bottomSheetExpanded
                                ? const SizedBox(width: double.infinity)
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      DateFormat.yMMMd('ru_RU').format(
                                        weatherState.weather.current.dateTime,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    MyIconButton(
                      onTap: () =>
                          AutoRouter.of(context).push(const SearchRoute()),
                      icon: const Icon(
                        CupertinoIcons.plus_circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListTileTheme(
        iconColor: Theme.of(context).colorScheme.onBackground,
        style: ListTileStyle.drawer,
        child: SafeArea(
          child: Padding(
            padding: const Pad(horizontal: 20, top: 30),
            child: ListView(
              children: [
                Text(
                  'Weather app',
                  style: Theme.of(context).textTheme.headline2,
                ),
                ListTile(
                  onTap: () =>
                      AutoRouter.of(context).push(const SettingsRoute()),
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Настройки'),
                ),
                ListTile(
                  onTap: () =>
                      AutoRouter.of(context).push(const FavoritesRoute()),
                  leading: const Icon(Icons.favorite_border_rounded),
                  title: const Text('Избранные'),
                ),
                ListTile(
                  onTap: () => AutoRouter.of(context).push(const AboutRoute()),
                  leading: const Icon(Icons.account_circle_outlined),
                  title: const Text('О приложении'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeBottomSheetContent extends StatelessWidget {
  final bool expanded;
  const HomeBottomSheetContent(this.expanded, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const Pad(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: OverflowBox(
        alignment: Alignment.topCenter,
        maxHeight: double.infinity,
        child: Column(
          children: [
            Container(
              padding: const Pad(vertical: 14.5),
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 60,
                height: 3,
              ),
            ),
            SettingsBlocBuilder(builder: (context, settingsState) {
              return WeatherBlocBuilder(
                builder: (context, weatherState) => Column(
                  children: [
                    AnimatedSizeAndFade.showHide(
                      show: expanded,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const Pad(bottom: 32),
                          child: Text(
                            DateFormat('d MMMM', 'ru_RU').format(
                              weatherState.weather.current.dateTime,
                            ),
                          ),
                        ),
                      ),
                      sizeDuration: const Duration(milliseconds: 300),
                      fadeDuration: const Duration(milliseconds: 300),
                    ),
                    cardsRow(weatherState.weather, settingsState.settings),
                    const SizedBox(height: 16),
                    AnimatedSizeAndFade.showHide(
                      show: !expanded,
                      child: OutlinedButton(
                        onPressed: () => AutoRouter.of(context).push(
                          const WeekForecastRoute(),
                        ),
                        child: const Text(
                          'Прогноз на неделю',
                        ),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primaryVariant,
                          ),
                          side: MaterialStateProperty.all(BorderSide(
                            color: Theme.of(context).colorScheme.primaryVariant,
                          )),
                        ),
                      ),
                      sizeDuration: const Duration(milliseconds: 300),
                      fadeDuration: const Duration(milliseconds: 300),
                    ),
                    AnimatedSize(
                      alignment: Alignment.topCenter,
                      child: expanded
                          ? Padding(
                              padding: const Pad(top: 16),
                              child: weatherIndicators(
                                context,
                                weatherState.weather,
                                settingsState.settings,
                              ),
                            )
                          : const SizedBox(width: double.infinity),
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget cardsRow(Weather weather, Settings settings) {
    final weatherOnHours = <String, WeatherData>{
      "06:00": getWeatherOnHour(weather, 6),
      "12:00": getWeatherOnHour(weather, 12),
      "18:00": getWeatherOnHour(weather, 18),
      "00:00": getWeatherOnHour(weather, 0),
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weatherOnHours.entries.map(
        (entry) {
          var iconAssetGen = WeatherBloc.getIconFromWeather(entry.value);
          return timeCard(
            entry.key,
            iconAssetGen.image(),
            entry.value.temp.toInt().toString() +
                settings.temperatureUnits.inString,
          );
        },
      ).toList(),
    );
  }

  Widget timeCard(
    String time,
    Widget icon,
    String temperature,
  ) {
    return Builder(builder: (context) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 65, minHeight: 122),
        child: Neumorphic(
          padding: const Pad(horizontal: 9, vertical: 5),
          style: NeumorphicStyle(
            depth: 3,
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(time),
              const SizedBox(height: 11),
              SizedBox(height: 40, width: 40, child: icon),
              const SizedBox(height: 13),
              Text(temperature),
            ],
          ),
        ),
      );
    });
  }

  WeatherData getWeatherOnHour(Weather weather, int hourNum) {
    return weather.hourly
        .getRange(0, 24)
        .where((element) => element.dateTime.hour == hourNum)
        .first;
  }

  Widget cardIcon(Widget icon) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.white.withOpacity(0.01),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: icon,
      );
    });
  }

  Widget weatherIndicators(
    BuildContext context,
    Weather weather,
    Settings settings,
  ) {
    return Table(
      defaultColumnWidth: const FlexColumnWidth(1),
      columnWidths: const {
        1: FixedColumnWidth(20),
      },
      children: [
        TableRow(
          children: [
            TableCell(
              child: weatherIndicatorCard(
                Assets.icons.universal.thermometer.path,
                weather.current.temp.toStringAsFixed(1),
                settings.temperatureUnits.inString,
              ),
            ),
            const SizedBox(),
            TableCell(
              child: weatherIndicatorCard(
                Assets.icons.universal.humidity.path,
                weather.current.humidity.toString(),
                '%',
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const Pad(top: 8),
                child: weatherIndicatorCard(
                  Assets.icons.universal.breeze.path,
                  weather.current.windSpeed.toStringAsFixed(1),
                  settings.speedUnits.inString,
                ),
              ),
            ),
            const SizedBox(),
            TableCell(
              child: Padding(
                padding: const Pad(top: 8),
                child: weatherIndicatorCard(
                  Assets.icons.universal.barometer.path,
                  weather.current.pressure.toStringAsFixed(0),
                  settings.pressureUnits.inString,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget weatherIndicatorCard(String iconAsset, String text1, String text2) {
    return Builder(
      builder: (context) {
        return Neumorphic(
          style: NeumorphicStyle(color: Theme.of(context).colorScheme.surface),
          padding: const Pad(vertical: 20, horizontal: 8),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconAsset,
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 12),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: text1),
                      TextSpan(
                        text: text2,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WeatherBlocBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, WeatherSuccess state) builder;

  const WeatherBlocBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      if (state is WeatherSuccess) {
        return builder(context, state);
      } else if (state is WeatherLoadInProgress) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is WeatherFailure) {
        return ErrorText(state.message);
      } else {
        return const ErrorText(weatherUnknowFailureMessage);
      }
    });
  }
}

class SettingsBlocBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, SettingsSuccess state) builder;

  const SettingsBlocBuilder({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is SettingsSuccess) {
        return builder(context, state);
      } else if (state is SettingsFailure) {
        return ErrorText(state.message);
      } else {
        return const ErrorText(settingsUnknowFailureMessage);
      }
    });
  }
}

class ErrorText extends StatelessWidget {
  final String text;

  const ErrorText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.red[700]),
        textAlign: TextAlign.center,
      ),
    );
  }
}
