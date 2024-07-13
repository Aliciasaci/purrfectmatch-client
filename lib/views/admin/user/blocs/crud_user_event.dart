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
  final String userId;
  final BuildContext context;

  DeleteUser(this.userId, this.context);
}
