import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChangedEvent extends SearchEvent {
  const SearchQueryChangedEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class SearchByFirstLetterEvent extends SearchEvent {
  const SearchByFirstLetterEvent(this.letter);

  final String letter;

  @override
  List<Object?> get props => [letter];
}

class SearchClearEvent extends SearchEvent {
  const SearchClearEvent();
}
