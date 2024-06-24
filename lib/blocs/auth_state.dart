part of 'auth_bloc.dart';

@immutable

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  final User user;

  AuthAuthenticated({required this.token, required this.user});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}