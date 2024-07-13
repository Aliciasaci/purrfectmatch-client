part of 'crud_race_bloc.dart';

@immutable
abstract class CrudRaceState {}

class CrudRaceInitial extends CrudRaceState {}

class CrudRaceLoading extends CrudRaceState {}

class CrudRaceLoaded extends CrudRaceState {
  final List<Race> races;

  CrudRaceLoaded(this.races);
}

class CrudRaceError extends CrudRaceState {
  final String message;

  CrudRaceError(this.message);
}

class CrudRaceCreated extends CrudRaceState {
  final Race race;

  CrudRaceCreated(this.race);
}

class CrudRaceUpdated extends CrudRaceState {
  final Race race;

  CrudRaceUpdated(this.race);
}

class CrudRaceDeleted extends CrudRaceState {}
