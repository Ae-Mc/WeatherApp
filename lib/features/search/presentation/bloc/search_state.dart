part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class NoPropsState extends SearchState {
  const NoPropsState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends NoPropsState {}

class SearchInProgress extends NoPropsState {}

class SearchSuccess extends SearchState {
  final List<Place> places;

  const SearchSuccess(this.places);

  @override
  List<Object?> get props => [places];
}

class SearchFailure extends SearchState {
  final String message;

  const SearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}
