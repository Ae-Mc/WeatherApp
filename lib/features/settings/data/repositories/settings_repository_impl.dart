import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:weather_app/features/settings/data/models/settings_model.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_app/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      return Right(await localDataSource.getSettings());
    } on CacheException {
      return const Right(Settings.defaultSettings());
    }
  }

  @override
  Future<Either<Failure, void>> setSettings(Settings newSettings) async {
    await localDataSource
        .cacheSettings(SettingsModel.fromSettings(newSettings));
    return const Right(null);
  }
}
