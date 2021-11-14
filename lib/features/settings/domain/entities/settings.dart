import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';

part 'settings.g.dart';

@CopyWith()
class Settings extends Equatable {
  final TemperatureUnits temperatureUnits;
  final SpeedUnits speedUnits;
  final PressureUnits pressureUnits;
  final ThemeMode themeMode;
  final Place activePlace;
  final List<Place> favorites;

  const Settings({
    required this.temperatureUnits,
    required this.speedUnits,
    required this.pressureUnits,
    required this.themeMode,
    required this.activePlace,
    required this.favorites,
  });

  const Settings.defaultSettings()
      : temperatureUnits = TemperatureUnits.celcius,
        speedUnits = SpeedUnits.metersPerSecond,
        pressureUnits = PressureUnits.mmOfMercury,
        themeMode = ThemeMode.system,
        activePlace = const Place(
          name: 'Санкт-Петербург',
          latitude: 59.93863,
          longitude: 30.31413,
          population: -1,
        ),
        favorites = const [];

  @override
  List<Object?> get props => [
        temperatureUnits,
        speedUnits,
        pressureUnits,
        themeMode,
        activePlace,
      ];

  @override
  bool? get stringify => true;
}

enum TemperatureUnits { celcius, farenheit }
enum SpeedUnits { metersPerSecond, kilometersPerHour }
enum PressureUnits { mmOfMercury, hectopascal }
