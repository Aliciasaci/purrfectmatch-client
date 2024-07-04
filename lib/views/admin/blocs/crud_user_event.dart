part of 'crud_user_bloc.dart';

@immutable

abstract class CrudUserEvent {}

class LoadUsers extends CrudUserEvent {}

class CreateUser extends CrudUserEvent {
  final User user;

  CreateUser(this.user);
}

class UpdateUser extends CrudUserEvent {
  final User user;

  UpdateUser(this.user);
}

class DeleteUser extends CrudUserEvent {
  final int userId;

  DeleteUser(this.userId);
}