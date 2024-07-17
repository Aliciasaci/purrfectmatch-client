import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:purrfectmatch/models/cat.dart';
import 'package:purrfectmatch/models/message.dart';
import 'package:purrfectmatch/models/room.dart';
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
  late Future<List<Map<String, dynamic>>> roomsDataFuture;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() {
    BlocProvider.of<RoomBloc>(context).add(LoadRooms());
  }

  Future<List<Map<String, dynamic>>> _loadAllRoomsData(List<Room> rooms) async {
    final currentUser = await authService.getCurrentUser();
    return Future.wait(rooms.map((room) async {
      final annonce =
          await apiService.fetchAnnonceByID(room.annonceID.toString());
      final cat = await apiService.fetchCatByID(annonce.CatID.toString());
      final latestMessage = await apiService.getLatestMessage(room.id!);
      return {
        'room': room,
        'annonce': annonce,
        'cat': cat,
        'latestMessage': latestMessage,
        'currentUser': currentUser,
      };
    }));
  }

  Widget _buildRoomListItem(Map<String, dynamic> data) {
    final room = data['room'] as Room;
    final Cat cat = data['cat'];
    final Message? latestMessage = data['latestMessage'];
    final User currentUser = data['currentUser'];
    final messageContent = latestMessage?.content ?? '';
    final isToday =
        latestMessage?.timestamp?.toLocal().day == DateTime.now().day &&
            latestMessage?.timestamp?.toLocal().month == DateTime.now().month &&
            latestMessage?.timestamp?.toLocal().year == DateTime.now().year;

    final DateTime? localTimestamp = latestMessage?.timestamp?.toLocal();
    final messageTimestamp = latestMessage == null
        ? ''
        : isToday
            ? localTimestamp != null
                ? DateFormat("HH:mm").format(localTimestamp)
                : ''
            : localTimestamp != null
                ? DateFormat("dd/MM").format(localTimestamp)
                : '';

    bool latestMessageIsRead = latestMessage?.isRead ?? true;
    if (latestMessage?.senderId == currentUser.id) {
      latestMessageIsRead = true;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: latestMessageIsRead
            ? null
            : const LinearGradient(
                colors: [Color(0xFFFA7D82), Color(0xFFFFB295)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        boxShadow: latestMessageIsRead
            ? null
            : [
                BoxShadow(
                    color: const Color(0xFFFFB295).withOpacity(0.6),
                    offset: const Offset(1.1, 4),
                    blurRadius: 8.0)
              ],
      ),
      alignment: Alignment.center,
      height: 70,
      child: ListTile(
        leading: ClipOval(
          child: Image.network(
            cat.picturesUrl[0],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
            style: const TextStyle(fontWeight: FontWeight.bold),
            "${room.annonceTitle!} - ${cat.name}"),
        subtitle: Text(
          style: TextStyle(
            color: latestMessageIsRead ? Colors.grey : Colors.white,
            fontWeight:
                latestMessageIsRead ? FontWeight.normal : FontWeight.bold,
          ),
          messageContent,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          messageTimestamp,
          style: TextStyle(
              color: latestMessageIsRead ? Colors.grey : Colors.white,
              fontSize: 10),
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
            roomsDataFuture = _loadAllRoomsData(state.rooms);
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: roomsDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                        _buildRoomListItem(snapshot.data![index]),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
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
