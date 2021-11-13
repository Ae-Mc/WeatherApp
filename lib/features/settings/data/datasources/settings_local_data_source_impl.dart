import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:weather_app/features/settings/data/models/settings_model.dart';

const cachedSettings = 'CACHED_SETTINGS';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheSettings(SettingsModel settingsModel) {
    return sharedPreferences.setString(
      cachedSettings,
      jsonEncode(settingsModel.toJson()),
    );
  }

  @override
  Future<SettingsModel> getSettings() async {
    final jsonString = sharedPreferences.getString(cachedSettings);
    if (jsonString == null) {
      throw const CacheException();
    }
    return SettingsModel.fromJson(jsonDecode(jsonString));
  }
}
