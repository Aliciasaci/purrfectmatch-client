import 'dart:async';
import 'dart:convert';

import 'package:purrfectmatch/models/message.dart';
import 'package:purrfectmatch/models/room.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:purrfectmatch/services/auth_service.dart';
import 'package:web_socket_channel/io.dart';
import '../../services/api_service.dart';
part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final ApiService apiService;
  final AuthService authService;
  StreamSubscription? _messageSubscription;
  IOWebSocketChannel? _channel;
  var currentUser;

  RoomBloc({required this.apiService, required this.authService})
      : super(RoomInitial()) {
    on<LoadRooms>(_onLoadRooms);
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    currentUser = await authService.getCurrentUser();
  }

  Future<void> _onLoadRooms(LoadRooms event, Emitter<RoomState> emit) async {
    emit(RoomInitial());
    try {
      final rooms = await apiService.getUserRooms();
      emit(RoomsLoaded(rooms: rooms));
    } catch (e) {
      emit(RoomError(message: 'Failed to load rooms.'));
    }
  }

  Future<void> _onLoadChatHistory(
      LoadChatHistory event, Emitter<RoomState> emit) async {
    emit(RoomInitial());
    try {
      final messages = await apiService.getRoomMessages(event.roomID);
      emit(RoomHistoryLoaded(messages: messages));

      _channel = apiService.connectToRoom(event.roomID);
      _messageSubscription = _channel!.stream.listen((message) {
        final messageData = Message.fromJson(json.decode(message));
        add(ReceiveMessage(messageData));
      },
          onError: (e) =>
              emit(RoomError(message: 'Failed to receive message.')),
          onDone: () => emit(RoomError(message: 'Connection closed.')));
    } catch (e) {
      emit(RoomError(message: 'Failed to load chat history.'));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<RoomState> emit) async {
    if (_channel != null) {
      _channel!.sink.add(event.content);
      emit(MessageSent());
    } else {
      emit(RoomError(message: 'Not connected to a room.'));
    }
  }

  Future<void> _onReceiveMessage(
      ReceiveMessage event, Emitter<RoomState> emit) async {
    if (state is RoomHistoryLoaded) {
      final currentMessages = (state as RoomHistoryLoaded).messages;
      emit(RoomHistoryLoaded(messages: [...currentMessages, event.message]));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _channel?.sink.close();
    return super.close();
  }
}
