import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final int errorCode;

  const ServerException(this.errorCode);

  @override
  List<Object?> get props => [errorCode];

  @override
  bool? get stringify => true;
}

class CacheException implements Exception {
  const CacheException();
}

class ConnectionException implements Exception {
  const ConnectionException();
}
