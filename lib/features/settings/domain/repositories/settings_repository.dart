import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Settings>> getSettings();
  Future<Either<Failure, void>> setSettings(Settings newSettings);
}
