import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:purrfectmatch/blocs/auth/auth_bloc.dart';
import 'package:purrfectmatch/blocs/room/room_bloc.dart';
import 'package:purrfectmatch/notificationManager.dart';
import 'package:purrfectmatch/models/annonce.dart';
import 'package:purrfectmatch/models/room.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/views/annonce/annonce_detail_page.dart';

class RoomScreen extends StatefulWidget {
  final Room room;
  final int? roomID;

  const RoomScreen({super.key, this.roomID, required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  User? _currentUser;
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  Annonce? annonce;

  @override
  void initState() {
    super.initState();
    NotificationManager.instance.setRoomID(widget.roomID!);
    BlocProvider.of<RoomBloc>(context).add(LoadChatHistory(widget.roomID));
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      _currentUser = authState.user;
    }
    String annonceIDString = widget.room.annonceID.toString();
    _apiService.fetchAnnonceByID(annonceIDString).then((value) {
      setState(() {
        annonce = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(widget.room.annonceTitle!),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              NotificationManager.instance.setRoomID(-1);
              Navigator.of(context).pop();
              BlocProvider.of<RoomBloc>(context).add(LoadRooms());
            },
          ),
          actions: [
            if (annonce != null)
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AnnonceDetailPage(annonce: annonce!),
                  ));
                },
              ),
          ]),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                BlocBuilder<RoomBloc, RoomState>(
                  builder: (context, state) {
                    if (state is RoomHistoryLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      });
                      // get the other user from the room context
                      final otherUserID =
                          widget.room.user1Id == _currentUser!.id!
                              ? widget.room.user2Id
                              : widget.room.user1Id;

                      final getOtherUser =
                          _apiService.fetchUserByID(otherUserID);

                      return FutureBuilder<User>(
                        future: getOtherUser,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final otherUser = snapshot.data!;
                            final currentUserPicture =
                                _currentUser!.profilePicURL == "default"
                                    ? _apiService.serveDefaultProfilePicture()
                                    : _currentUser!.profilePicURL;
                            final otherUserPicture =
                                otherUser.profilePicURL == "default"
                                    ? _apiService.serveDefaultProfilePicture()
                                    : otherUser.profilePicURL;
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: state.messages.map((message) {
                                  final isCurrentUser =
                                      message.senderId == _currentUser!.id!;
                                  final isToday =
                                      message.timestamp!.toLocal().day ==
                                              DateTime.now().day &&
                                          message.timestamp!.toLocal().month ==
                                              DateTime.now().month &&
                                          message.timestamp!.toLocal().year ==
                                              DateTime.now().year;
                                  final formattedTimestamp = isToday
                                      ? DateFormat("HH:mm")
                                          .format(message.timestamp!.toLocal())
                                      : DateFormat("d/MM")
                                          .format(message.timestamp!.toLocal());
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: isCurrentUser
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: isCurrentUser
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16),
                                              decoration: BoxDecoration(
                                                color: isCurrentUser
                                                    ? Colors.orange[100]
                                                    : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    isCurrentUser
                                                        ? CrossAxisAlignment.end
                                                        : CrossAxisAlignment
                                                            .start,
                                                children: [
                                                  Text(message.content!),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: isCurrentUser
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                if (!isCurrentUser)
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            otherUserPicture!),
                                                  ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  formattedTimestamp,
                                                  style: const TextStyle(
                                                      fontSize: 8),
                                                ),
                                                const SizedBox(width: 5),
                                                if (isCurrentUser)
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            currentUserPicture!),
                                                  ),
                                                if (isCurrentUser &&
                                                    message.isRead!)
                                                  const Row(
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Icon(
                                                        Icons.check,
                                                        size: 15,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                snapshot.error.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    } else if (state is RoomError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
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
                      hintText: 'Entrez votre message',
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
