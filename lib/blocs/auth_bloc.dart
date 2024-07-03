import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.login(event.email, event.password);
      final user = await authService.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(token: AuthService.authToken!, user: user));
      } else {
        emit(AuthError(message: 'Failed to retrieve user.'));
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to login.'));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    authService.logout();
    emit(AuthInitial());
  }

  Future<void> _onUpdateProfileRequested(UpdateProfileRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final updatedUser = await authService.updateProfile(event.user);
      if (updatedUser != null) {
        emit(AuthAuthenticated(token: AuthService.authToken!, user: updatedUser));
      } else {
        emit(AuthError(message: 'Failed to update profile.'));
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to update profile.'));
    }
  }
}
