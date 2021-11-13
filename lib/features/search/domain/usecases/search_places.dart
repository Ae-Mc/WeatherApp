import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/search/domain/repositories/search_repository.dart';

class SearchPlaces extends UseCase<List<Place>, Params> {
  final SearchRepository repository;

  SearchPlaces(this.repository);

  @override
  Future<Either<Failure, List<Place>>> call(Params params) async {
    return repository.searchPlaces(params.query);
  }
}

@immutable
class Params extends Equatable {
  final String query;

  const Params({required this.query});

  @override
  List<Object?> get props => [query];
}
