part of 'crud_user_bloc.dart';

@immutable
abstract class CrudUserState {}

class CrudUserInitial extends CrudUserState {}

class CrudUserLoading extends CrudUserState {}

class CrudUserLoaded extends CrudUserState {
  final List<User> users;

  CrudUserLoaded(this.users);
}

class CrudUserError extends CrudUserState {
  final String message;

  CrudUserError(this.message);
}

class CrudUserCreated extends CrudUserState {
  final User user;

  CrudUserCreated(this.user);
}

class CrudUserUpdated extends CrudUserState {
  final User user;

  CrudUserUpdated(this.user);
}

class CrudUserDeleted extends CrudUserState {}
