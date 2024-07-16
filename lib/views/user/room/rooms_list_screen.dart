import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/annonce.dart';
import 'package:purrfectmatch/models/cat.dart';
import 'package:purrfectmatch/models/message.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/services/auth_service.dart';
import '../../../blocs/room/room_bloc.dart';
import 'room_screen.dart';

class RoomsListScreen extends StatefulWidget {
  const RoomsListScreen({super.key});

  @override
  State<RoomsListScreen> createState() => _RoomsListScreenState();
}

class _RoomsListScreenState extends State<RoomsListScreen> {
  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() {
    BlocProvider.of<RoomBloc>(context).add(LoadRooms());
  }

  Future<Map<String, dynamic>> _loadRoomData(
      String annonceID, int roomID) async {
    final annonce = await apiService.fetchAnnonceByID(annonceID);
    final cat = await apiService.fetchCatByID(annonce.CatID.toString());
    final author = await apiService.fetchUserByID(annonce.UserID);
    final latestMessage = await apiService.getLatestMessage(roomID);
    final currentUser = await authService.getCurrentUser();
    return {
      'annonce': annonce,
      'cat': cat,
      'author': author,
      'latestMessage': latestMessage,
      'currentUser': currentUser,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          if (state is RoomsLoaded) {
            if (state.rooms.isEmpty) {
              return const Center(
                child: Text(
                  'Vous n\'avez pas encore de conversations. Likez des annonces pour commencer à discuter !',
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              itemCount: state.rooms.length,
              itemBuilder: (context, index) {
                final room = state.rooms[index];
                return FutureBuilder<Map<String, dynamic>>(
                  future: _loadRoomData(room.annonceID.toString(), room.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final data = snapshot.data!;
                      final Cat cat = data['cat'];
                      final User author = data['author'];
                      final Message? latestMessage = data['latestMessage'];
                      final User currentUser = data['currentUser'];
                      final messageContent = latestMessage?.content ?? '';
                      final messageTimestamp =
                          latestMessage?.timestamp?.toLocal().toString() ?? '';

                      bool latestMessageIsRead = latestMessage?.isRead ?? true;
                      if (latestMessage?.senderId == currentUser.id) {
                        latestMessageIsRead = true;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          gradient: latestMessageIsRead
                              ? null
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFFEDE7F6),
                                    Color(0xFFD1C4E9),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                        ),
                        alignment: Alignment.center,
                        height: 70,
                        /*decoration: BoxDecoration(
                          border: Border(
                            bottom: const BorderSide(
                                color: Colors.grey, width: 0.5),
                            top: index == 0
                                ? const BorderSide(
                                    color: Colors.grey, width: 0.5)
                                : BorderSide.none,
                          ),
                        ),*/
                        child: ListTile(
                          leading: ClipOval(
                            child: Image.network(
                              cat.picturesUrl[0],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text("${room.annonceTitle!} - ${cat.name}"),
                          subtitle: Text(
                            messageContent,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            messageTimestamp,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RoomScreen(room: room),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
              },
            );
          } else if (state is RoomError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
