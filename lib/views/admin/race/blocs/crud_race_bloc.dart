import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/race.dart';
import 'package:purrfectmatch/services/api_service.dart';

part 'crud_race_event.dart';
part 'crud_race_state.dart';

class CrudRaceBloc extends Bloc<CrudRaceEvent, CrudRaceState> {
  final ApiService apiService;

  CrudRaceBloc({required this.apiService}) : super(CrudRaceInitial()) {
    on<LoadRaces>(_onLoadRaces);
    on<CreateRace>(_onCreateRace);
    on<UpdateRace>(_onUpdateRace);
    on<DeleteRace>(_onDeleteRace);
  }

  Future<void> _onLoadRaces(LoadRaces event, Emitter<CrudRaceState> emit) async {
    emit(CrudRaceLoading());
    try {
      final races = await apiService.fetchAllRaces();
      emit(CrudRaceLoaded(races));
    } catch (e) {
      emit(CrudRaceError('Failed to load races.'));
    }
  }

  Future<void> _onCreateRace(CreateRace event, Emitter<CrudRaceState> emit) async {
    try {
      await apiService.createRace(event.race);
      emit(CrudRaceCreated(event.race));
      add(LoadRaces());
    } catch (e) {
      emit(CrudRaceError('Failed to create race.'));
    }
  }

  Future<void> _onUpdateRace(UpdateRace event, Emitter<CrudRaceState> emit) async {
    emit(CrudRaceLoading());
    try {
      await apiService.updateRace(event.race);
      emit(CrudRaceUpdated(event.race));
      add(LoadRaces());
    } catch (e) {
      emit(CrudRaceError('Failed to update race.'));
    }
  }

  Future<void> _onDeleteRace(DeleteRace event, Emitter<CrudRaceState> emit) async {
    emit(CrudRaceLoading());
    try {
      await apiService.deleteRace(event.raceId);
      emit(CrudRaceDeleted());
      add(LoadRaces());
    } catch (e) {
      emit(CrudRaceError('Failed to delete race.'));
    }
  }
}
