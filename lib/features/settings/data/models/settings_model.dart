import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/features/search/data/models/place_model.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';

part 'settings_model.g.dart';

@JsonSerializable()
class SettingsModel extends Equatable implements Settings {
  @override
  final PlaceModel activePlace;
  @override
  final PressureUnits pressureUnits;
  @override
  final SpeedUnits speedUnits;
  @override
  final TemperatureUnits temperatureUnits;
  @override
  final ThemeMode themeMode;
  @override
  final List<PlaceModel> favorites;

  const SettingsModel({
    required this.activePlace,
    required this.pressureUnits,
    required this.speedUnits,
    required this.temperatureUnits,
    required this.themeMode,
    required this.favorites,
  });

  factory SettingsModel.fromSettings(Settings settings) => SettingsModel(
        activePlace: PlaceModel.fromPlace(settings.activePlace),
        pressureUnits: settings.pressureUnits,
        speedUnits: settings.speedUnits,
        temperatureUnits: settings.temperatureUnits,
        themeMode: settings.themeMode,
        favorites:
            settings.favorites.map((e) => PlaceModel.fromPlace(e)).toList(),
      );

  @override
  List<Object?> get props => [
        activePlace,
        pressureUnits,
        speedUnits,
        temperatureUnits,
        themeMode,
        favorites,
      ];

  @override
  bool? get stringify => true;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
}
