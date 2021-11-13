import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/search/data/models/place_model.dart';
import 'package:weather_app/features/settings/data/models/settings_model.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';

void main() {
  group('SettingsModel tests', () {
    test('Test Settings to SettingsModel cast', () {
      const defaultSettings = Settings.defaultSettings();
      expect(
        SettingsModel.fromSettings(defaultSettings),
        SettingsModel(
          activePlace: PlaceModel(
            country: defaultSettings.activePlace.country,
            name: defaultSettings.activePlace.name,
            latitude: defaultSettings.activePlace.latitude,
            longitude: defaultSettings.activePlace.longitude,
            population: defaultSettings.activePlace.population,
          ),
          pressureUnits: defaultSettings.pressureUnits,
          speedUnits: defaultSettings.speedUnits,
          temperatureUnits: defaultSettings.temperatureUnits,
          themeMode: defaultSettings.themeMode,
          favorites: const [],
        ),
      );
    });
  });
}
