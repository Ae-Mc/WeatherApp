import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/search/domain/repositories/search_repository.dart';
import 'package:weather_app/features/search/domain/usecases/search_places.dart';
part 'search_event.dart';
part 'search_state.dart';

const serverErrorMessage =
    'Произошла ошибка при обработку запроса. Код ошибки: {}';
const connectionErrorMessage =
    'Произошла ошибка при подключении к серверу. Возможно, у вас нет соединения с интернетом?';
const unknownErrorMessage = 'Произошла неизвестная ошибка при поиске.';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final SearchPlaces searchPlaces;

  SearchBloc() : super(Initial()) {
    on<Init>((event, emit) {
      emit(Loading());
      searchPlaces = SearchPlaces(event.repository);
      emit(Empty());
    });
    on<Search>((event, emit) async {
      emit(Loading());
      (await searchPlaces(Params(query: event.query))).fold(
        (l) => emit(Error(mapFailureToMessage(l))),
        (r) => emit(Loaded(r)),
      );
    });
    on<Clear>((event, emit) => emit(Empty()));
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ConnectionFailure:
        return connectionErrorMessage;
      case ServerFailure:
        return serverErrorMessage.replaceFirst(
            '{}', (failure as ServerFailure).errorCode.toString());
      default:
        return unknownErrorMessage;
    }
  }
}
