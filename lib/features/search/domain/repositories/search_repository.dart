import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Place>>> searchPlaces(String query);
}
