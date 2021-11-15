part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchInitialized extends SearchEvent {
  final SearchRepository repository;

  const SearchInitialized(this.repository);

  @override
  List<Object?> get props => [repository];
}

class SearchSearched extends SearchEvent {
  final String query;

  const SearchSearched(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}
