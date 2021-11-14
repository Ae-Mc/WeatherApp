part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class Init extends SearchEvent {
  final SearchRepository repository;

  const Init(this.repository);

  @override
  List<Object?> get props => [repository];
}

class Search extends SearchEvent {
  final String query;

  const Search(this.query);

  @override
  List<Object?> get props => [query];
}

class Clear extends SearchEvent {
  @override
  List<Object?> get props => [];
}
