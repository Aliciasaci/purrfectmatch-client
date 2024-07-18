import 'dart:async';
import 'dart:convert';

import 'package:purrfectmatch/models/message.dart';
import 'package:purrfectmatch/models/room.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../../services/api_service.dart';
part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final ApiService apiService;
  StreamSubscription? _messageSubscription;
  IOWebSocketChannel? _channel;
  List<Message> get currentMessages =>
      (state is RoomHistoryLoaded) ? (state as RoomHistoryLoaded).messages : [];

  RoomBloc({required this.apiService}) : super(RoomInitial()) {
    on<LoadRooms>(_onLoadRooms);
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  void disconnectCurrentConnection() {
    _messageSubscription?.cancel();
    _channel?.sink.close();
    _messageSubscription = null;
    _channel = null;
  }

  Future<void> _onLoadRooms(LoadRooms event, Emitter<RoomState> emit) async {
    try {
      final rooms = await apiService.getUserRooms();
      emit(RoomsLoaded(rooms: rooms));
    } catch (e) {
      emit(RoomError(message: 'Failed to load rooms.'));
    }
  }

  Future<void> _onLoadChatHistory(
      LoadChatHistory event, Emitter<RoomState> emit) async {
    disconnectCurrentConnection();
    try {
      final messages = await apiService.getRoomMessages(event.roomID!);
      emit(RoomHistoryLoaded(messages: messages));

      _channel = apiService.connectToRoom(event.roomID!);
      if (_channel != null) {
        _messageSubscription = _channel!.stream.listen((message) {
          final messageData = Message.fromJson(json.decode(message));
          add(ReceiveMessage(messageData));
        },
            onError: (e) =>
                emit(RoomError(message: 'Failed to receive message.')),
            onDone: () => emit(RoomError(message: 'Connection closed.')));
      } else {
        // Handle the case when _channel is null
        emit(RoomError(message: 'WebSocket channel is not initialized.'));
      }
    } catch (e) {
      emit(RoomError(message: 'Failed to load chat history. $e'));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<RoomState> emit) async {
    if (_channel != null) {
      _channel!.sink.add(event.content);
    } else {
      emit(RoomError(message: 'Not connected to a room.'));
    }
  }

  Future<void> _onReceiveMessage(
      ReceiveMessage event, Emitter<RoomState> emit) async {
    currentMessages.add(event.message);
    emit(RoomHistoryLoaded(messages: currentMessages));
  }

  @override
  Future<void> close() {
    disconnectCurrentConnection();
    return super.close();
  }
}
