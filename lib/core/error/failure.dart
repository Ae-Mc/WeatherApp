import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure();

  @override
  get props => [];

  @override
  bool get stringify => true;
}

class ConnectionFailure extends Failure {
  const ConnectionFailure();
}

class ServerFailure extends Failure {
  final int errorCode;

  const ServerFailure(this.errorCode);

  @override
  List<Object?> get props => [errorCode];
}
