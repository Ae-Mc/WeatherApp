import 'package:equatable/equatable.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class GetWeather extends UseCase<Weather, Params> {
  final WeatherRepository repository;

  GetWeather(this.repository);

  @override
  Future<Either<Failure, Weather>> call(Params params) {
    return repository.getWeather(params.place);
  }
}

class Params extends Equatable {
  final Place place;

  const Params(this.place);

  @override
  List<Object?> get props => [place];
}
