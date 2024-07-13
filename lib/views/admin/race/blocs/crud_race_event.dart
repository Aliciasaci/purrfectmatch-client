part of 'crud_race_bloc.dart';

@immutable
abstract class CrudRaceEvent {}

class LoadRaces extends CrudRaceEvent {}

class CreateRace extends CrudRaceEvent {
  final Race race;

  CreateRace(this.race);
}

class UpdateRace extends CrudRaceEvent {
  final Race race;

  UpdateRace(this.race);
}

class DeleteRace extends CrudRaceEvent {
  final int raceId;
  final BuildContext context;

  DeleteRace(this.raceId, this.context);
}
