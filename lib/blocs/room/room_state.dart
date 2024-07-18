part of 'room_bloc.dart';

@immutable
abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomsLoaded extends RoomState {
  final List<Room> rooms;

  RoomsLoaded({required this.rooms});
}

class RoomHistoryLoaded extends RoomState {
  final List<Message> messages;

  RoomHistoryLoaded({required this.messages});
}

class MessageSent extends RoomState {}

class RoomError extends RoomState {
  final String message;

  RoomError({required this.message});
}
