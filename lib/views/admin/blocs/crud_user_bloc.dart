import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:purrfectmatch/services/api_service.dart';

part 'crud_user_event.dart';
part 'crud_user_state.dart';

class CrudUserBloc extends Bloc<CrudUserEvent, CrudUserState> {
  final ApiService apiService;

  CrudUserBloc({required this.apiService}) : super(CrudUserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<CrudUserState> emit) async {
    emit(CrudUserLoading());
    try {
      final users = await apiService.fetchAllUsers();
      emit(CrudUserLoaded(users));
    } catch (e) {
      emit(CrudUserError('Failed to load users.'));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<CrudUserState> emit) async {
    try {
      await apiService.createUser(event.user);
      emit(CrudUserCreated(event.user));
      add(LoadUsers());
    } catch (e) {
      emit(CrudUserError('Failed to create user.'));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<CrudUserState> emit) async {
    emit(CrudUserLoading());
    try {
      await apiService.updateUser(event.user);
      emit(CrudUserUpdated(event.user));
      add(LoadUsers());
    } catch (e) {
      emit(CrudUserError('Failed to update user.'));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<CrudUserState> emit) async {
    emit(CrudUserLoading());
    try {
      await apiService.deleteUser(event.userId);
      emit(CrudUserDeleted());
      add(LoadUsers());
    } catch (e) {
      print('error: $e');
      emit(CrudUserError('Failed to delete user. ${e.toString()}'));
    }
  }
}
