import 'package:equatable/equatable.dart';

const serverErrorMessage =
    'Произошла ошибка при обработке запроса. Код ошибки: {}';
const connectionErrorMessage =
    'Произошла ошибка при подключении к серверу. Возможно, у вас нет соединения с интернетом?';

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
