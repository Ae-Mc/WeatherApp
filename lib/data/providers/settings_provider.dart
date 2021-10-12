import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TemperatureUnits { celcius, farenheit }
enum SpeedUnits { metersPerSecond, kilometersPerHour }
enum PressureUnits { mmOfMercury, gigaPascal }

extension ParseTempToString on TemperatureUnits {
  String get inString => ['˚c', '˚F'][index];
}

extension ParseSpeedToString on SpeedUnits {
  String get inString => ['м/с', 'км/ч'][index];
}

extension ParsePressureToString on PressureUnits {
  String get inString => ['мм.рт.ст', 'гПа'][index];
}

class SettingsProvider extends ChangeNotifier implements ReassembleHandler {
  TemperatureUnits _temperatureUnits;
  SpeedUnits _speedUnits;
  PressureUnits _pressureUnits;
  ThemeMode _themeMode;

  TemperatureUnits get temperatureUnits => _temperatureUnits;
  SpeedUnits get speedUnits => _speedUnits;
  PressureUnits get pressureUnits => _pressureUnits;
  ThemeMode get themeMode => _themeMode;

  set temperatureUnits(TemperatureUnits newValue) =>
      notify(() => _temperatureUnits = newValue);
  set speedUnits(SpeedUnits newValue) => notify(() => _speedUnits = newValue);
  set pressureUnits(PressureUnits newValue) =>
      notify(() => _pressureUnits = newValue);
  set themeMode(ThemeMode newValue) => notify(() => _themeMode = newValue);

  void switchTemperatureUnits() {
    temperatureUnits = temperatureUnits == TemperatureUnits.celcius
        ? TemperatureUnits.farenheit
        : TemperatureUnits.celcius;
  }

  void switchSpeedUnits() {
    speedUnits = speedUnits == SpeedUnits.metersPerSecond
        ? SpeedUnits.kilometersPerHour
        : SpeedUnits.metersPerSecond;
  }

  void switchPressureUnits() {
    pressureUnits = pressureUnits == PressureUnits.gigaPascal
        ? PressureUnits.mmOfMercury
        : PressureUnits.gigaPascal;
  }

  void switchTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  SettingsProvider({
    required TemperatureUnits temperatureUnits,
    required SpeedUnits speedUnits,
    required PressureUnits pressureUnits,
    required ThemeMode themeMode,
  })  : _temperatureUnits = temperatureUnits,
        _speedUnits = speedUnits,
        _pressureUnits = pressureUnits,
        _themeMode = themeMode;

  void notify(Function f) {
    f();
    notifyListeners();
  }

  @override
  void reassemble() {}
}
