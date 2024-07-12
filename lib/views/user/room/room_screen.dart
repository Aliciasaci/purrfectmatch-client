import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:purrfectmatch/blocs/auth_bloc.dart';
import 'package:purrfectmatch/blocs/room/room_bloc.dart';

class RoomScreen extends StatefulWidget {
  final int roomID;
  final String annonceTitle;

  const RoomScreen(
      {super.key, required this.roomID, required this.annonceTitle});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? _currentUserID;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RoomBloc>(context).add(LoadChatHistory(widget.roomID));
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      _currentUserID = authState.user.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.annonceTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                BlocBuilder<RoomBloc, RoomState>(
                  builder: (context, state) {
                    if (state is RoomHistoryLoaded) {
                      return Column(
                        children: state.messages.map((message) {
                          final isCurrentUser =
                              message.senderId == _currentUserID;

                          final today = DateTime.now();
                          final isToday =
                              today.year == message.timestamp.year &&
                                  today.month == message.timestamp.month &&
                                  today.day == message.timestamp.day;

                          final formattedDate = isToday
                              ? DateFormat("HH:mm").format(message.timestamp)
                              : DateFormat("dd/MM/yyyy")
                                  .format(message.timestamp);

                          return ListTile(
                            title: Text(message.content),
                            subtitle: Text(formattedDate,
                                style: const TextStyle(fontSize: 12)),
                            tileColor: isCurrentUser
                                ? Colors.orange[100]
                                : Colors.grey[200],
                            contentPadding: EdgeInsets.only(
                              left: isCurrentUser ? 50 : 16,
                              right: isCurrentUser ? 16 : 50,
                            ),
                          );
                        }).toList(),
                      );
                    } else if (state is RoomError) {
                      return Center(
                        child: Text(
                          state.message,
                          selectionColor: Colors.white,
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    BlocProvider.of<RoomBloc>(context)
                        .add(SendMessage(_messageController.text));
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
