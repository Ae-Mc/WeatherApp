import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';
import 'package:weather_app/features/settings/domain/repositories/settings_repository.dart';

class SetSettings extends UseCase<void, Params> {
  final SettingsRepository repository;

  SetSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) =>
      repository.setSettings(params.settings);
}

class Params {
  final Settings settings;

  const Params(this.settings);
}
