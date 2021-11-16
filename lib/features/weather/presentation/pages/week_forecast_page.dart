import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/gen/assets.gen.dart';

class WeekForecastPage extends StatelessWidget {
  const WeekForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const Pad(vertical: 25, horizontal: 20),
          child: SizedBox.expand(
            child: Column(
              children: [
                Text(
                  'Прогноз на неделю',
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: OverflowBox(
                    maxWidth: MediaQuery.of(context).size.width,
                    child: BlocBuilder<WeatherBloc, WeatherState>(
                      builder: (context, state) {
                        if (state is WeatherSuccess) {
                          return CarouselSlider.builder(
                            itemCount: state.weather.daily.length,
                            itemBuilder: (context, index, _) =>
                                Builder(builder: (context) {
                              return WeatherCard(state.weather.daily[index]);
                            }),
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              viewportFraction: 0.9,
                              enlargeCenterPage: true,
                              height: double.infinity,
                            ),
                          );
                        } else if (state is WeatherLoadInProgress) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is WeatherFailure) {
                          return const SizedBox();
                        } else {
                          throw UnimplementedError();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Назад на главную'),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                        color: Theme.of(context).colorScheme.onBackground)),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final WeatherData weather;
  const WeatherCard(this.weather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const Pad(all: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.light
                ? [
                    const Color(0xFFCDDAF6),
                    const Color(0xFF9FBEFF),
                  ]
                : [
                    const Color(0xFF213A70),
                    const Color(0xFF102042),
                  ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('d MMMM', 'ru_RU').format(weather.dateTime),
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 16),
            WeatherBloc.getIconFromWeather(weather).image(height: 85),
            const SizedBox(height: 35),
            Align(
              alignment: Alignment.bottomLeft,
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsSuccess) {
                    return Column(
                      children: [
                        buildRow(
                          Assets.icons.universal.thermometer.path,
                          weather.temp.round().toString(),
                          state.settings.temperatureUnits.inString,
                        ),
                        const SizedBox(height: 24),
                        buildRow(
                          Assets.icons.universal.breeze.path,
                          weather.windSpeed.round().toString(),
                          state.settings.speedUnits.inString,
                        ),
                        const SizedBox(height: 24),
                        buildRow(
                          Assets.icons.universal.humidity.path,
                          weather.humidity.toString(),
                          '%',
                        ),
                        const SizedBox(height: 24),
                        buildRow(
                          Assets.icons.universal.barometer.path,
                          weather.pressure.round().toString(),
                          state.settings.pressureUnits.inString,
                        ),
                      ],
                    );
                  } else {
                    throw UnimplementedError();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Builder buildRow(String iconAsset, String text1, String text2) {
    return Builder(builder: (context) {
      return Row(
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
      );
    });
  }
}
