part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class GoogleLoginRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class UpdateProfileRequested extends AuthEvent {
  final User user;

  UpdateProfileRequested(this.user);
}

class UpdateProfilePicRequested extends AuthEvent {
  final User user;

  UpdateProfilePicRequested(this.user);
}
