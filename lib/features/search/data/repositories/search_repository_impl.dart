import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_app/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Place>>> searchPlaces(String query) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.searchPlaces(query));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.errorCode));
      } on ConnectionException {
        return const Left(ConnectionFailure());
      }
    } else {
      return const Left(ConnectionFailure());
    }
  }
}
