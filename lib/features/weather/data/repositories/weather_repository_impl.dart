import 'package:weather_app/core/error/handlers.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Weather>> getWeather(Place place) async {
    if (await networkInfo.isConnected) {
      return Handlers.handleRemoteDataSourceRequestExceptons(
        () async => (await remoteDataSource.getWeather(place)).toWeather(),
      );
    } else {
      return const Left(ConnectionFailure());
    }
  }
}
