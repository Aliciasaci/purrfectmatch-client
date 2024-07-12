part of 'room_bloc.dart';

@immutable
abstract class RoomEvent {}

class LoadRooms extends RoomEvent {}

class LoadChatHistory extends RoomEvent {
  final int roomID;

  LoadChatHistory(this.roomID);
}

class SendMessage extends RoomEvent {
  final String content;

  SendMessage(this.content);
}

class ReceiveMessage extends RoomEvent {
  final Message message;

  ReceiveMessage(this.message);
}
