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

  SearchBloc() : super(SearchInitial()) {
    on<SearchInitialized>((event, emit) {
      emit(SearchInProgress());
      searchPlaces = SearchPlaces(event.repository);
      emit(const SearchSuccess([]));
    });
    on<SearchSearched>((event, emit) async {
      emit(SearchInProgress());
      (await searchPlaces(Params(query: event.query))).fold(
        (l) => emit(SearchFailure(mapFailureToMessage(l))),
        (r) => emit(SearchSuccess(r)),
      );
    });
    on<SearchCleared>((event, emit) => emit(const SearchSuccess([])));
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
