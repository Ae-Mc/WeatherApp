import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/core/error/failure.dart';

class Handlers {
  static Future<T> handleDioRequestException<T>(
    Future<T> Function() request,
  ) async {
    try {
      return await request();
    } on DioError catch (e) {
      if (e.response?.statusCode == null) {
        throw const ConnectionException();
      } else {
        throw ServerException(e.response!.statusCode!);
      }
    }
  }

  static Future<Either<Failure, T>> handleRemoteDataSourceRequestExceptons<T>(
    Future<T> Function() request,
  ) async {
    try {
      return Right(await request());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorCode));
    } on ConnectionException {
      return const Left(ConnectionFailure());
    }
  }
}
