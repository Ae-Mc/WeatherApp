import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart' hide Switch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';
import 'package:weather_app/features/settings/presentation/widgets/custom_switch.dart';
import 'package:weather_app/widgets/page_header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _animationDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const Pad(horizontal: 20, top: 32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(title: 'Настройки'),
              const SizedBox(height: 32),
              Text(
                'Единицы измерения',
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 16),
              IntrinsicHeight(
                child: OverflowBox(
                  maxWidth: MediaQuery.of(context).size.width,
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, -4),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]),
                    child: Padding(
                      padding: const Pad(horizontal: 20),
                      child: BlocBuilder<SettingsBloc, SettingsState>(
                        buildWhen: (previousState, newState) {
                          return newState is! SettingsInProgress;
                        },
                        builder: (context, state) {
                          switch (state.runtimeType) {
                            case SettingsSuccess:
                              final curState = state as SettingsSuccess;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _switchRow(
                                    context: context,
                                    title: 'Температура',
                                    text1: '˚C',
                                    text2: '˚F',
                                    state: curState.settings.temperatureUnits ==
                                        TemperatureUnits.farenheit,
                                    onTap: () =>
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(
                                      SetringsTemperatureUnitsSet(
                                        curState.settings.temperatureUnits ==
                                                TemperatureUnits.celcius
                                            ? TemperatureUnits.farenheit
                                            : TemperatureUnits.celcius,
                                      ),
                                    ),
                                  ),
                                  _divider(),
                                  _switchRow(
                                    context: context,
                                    title: 'Сила ветра',
                                    text1: 'м/с',
                                    text2: 'км/ч',
                                    state: curState.settings.speedUnits ==
                                        SpeedUnits.kilometersPerHour,
                                    onTap: () =>
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(
                                      SettingsSpeedUnitsSet(
                                        curState.settings.speedUnits ==
                                                SpeedUnits.metersPerSecond
                                            ? SpeedUnits.kilometersPerHour
                                            : SpeedUnits.metersPerSecond,
                                      ),
                                    ),
                                  ),
                                  _divider(),
                                  _switchRow(
                                    context: context,
                                    title: 'Давление',
                                    text1: 'мм.рт.ст',
                                    text2: 'гПа',
                                    state: curState.settings.pressureUnits ==
                                        PressureUnits.hectopascal,
                                    onTap: () =>
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(
                                      SettingsPressureUnitsSet(
                                        curState.settings.pressureUnits ==
                                                PressureUnits.hectopascal
                                            ? PressureUnits.mmOfMercury
                                            : PressureUnits.hectopascal,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            case SettingsFailure:
                              return Text((state as SettingsFailure).message);
                            default:
                              return Text('Unknown settings state: $state');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Интерфейс',
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 16),
              BlocBuilder<SettingsBloc, SettingsState>(
                buildWhen: (oldState, newState) {
                  return newState is SettingsSuccess;
                },
                builder: (context, state) {
                  return _switchRow(
                    context: context,
                    title: 'Тема',
                    text1: 'Тёмная',
                    text2: 'Светлая',
                    state: (state as SettingsSuccess).settings.themeMode ==
                        ThemeMode.light,
                    onTap: () => BlocProvider.of<SettingsBloc>(context).add(
                      SettingsThemeModeSet(
                        state.settings.themeMode == ThemeMode.dark
                            ? ThemeMode.light
                            : ThemeMode.dark,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchRow(
      {required BuildContext context,
      required String title,
      required String text1,
      required String text2,
      required bool state,
      required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        padding: const Pad(vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.subtitle1),
            CustomSwitch(
              state: state,
              text1: text1,
              text2: text2,
              duration: _animationDuration,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1);
  }
}
