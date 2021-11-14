part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class NoPropsState extends SearchState {
  const NoPropsState();

  @override
  List<Object> get props => [];
}

class Initial extends NoPropsState {}

class Empty extends NoPropsState {}

class Loading extends NoPropsState {}

class Loaded extends SearchState {
  final List<Place> places;

  const Loaded(this.places);

  @override
  List<Object?> get props => [places];
}

class Error extends SearchState {
  final String message;

  const Error(this.message);

  @override
  List<Object?> get props => [message];
}
