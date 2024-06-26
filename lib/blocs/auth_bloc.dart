import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial());

  void login(String email, String password) async {
    emit(AuthLoading());
    try {
      await authService.login(email, password);
      final user = await authService.getCurrentUser();
      emit(AuthAuthenticated(token: AuthService.authToken!, user: user));
    } catch (e) {
      emit(AuthError(message: 'Failed to login.'));
    }
  }

  void logout() {
    authService.logout();
    emit(AuthInitial());
  }

  //NOTE: change back to void if use state for snackbar message
  updateProfile(User user) async {
    emit(AuthLoading());
    try {
      await authService.updateProfile(user);
      final updatedUser = await authService.getCurrentUser();

      if (updatedUser != null) {
        emit(AuthAuthenticated(token: AuthService.authToken!, user: updatedUser));
        return true;
      } else {
        emit(AuthError(message: 'Failed to update profile.'));
        return false;
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to update profile.'));
    }
  }
}
