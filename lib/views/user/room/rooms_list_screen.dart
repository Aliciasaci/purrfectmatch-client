import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/room/room_bloc.dart';
import 'room_screen.dart';

class RoomsListScreen extends StatefulWidget {
  const RoomsListScreen({super.key});

  @override
  State<RoomsListScreen> createState() => _RoomsListScreenState();
}

class _RoomsListScreenState extends State<RoomsListScreen> {
  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() async {
    BlocProvider.of<RoomBloc>(context).add(LoadRooms());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          if (state is RoomsLoaded) {
            if (state.rooms.isEmpty) {
              // Display a message when there are no rooms
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
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(room.annonceTitle!),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RoomScreen(
                            roomID: room.id!,
                            annonceTitle: room.annonceTitle!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is RoomError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            print('Unknown state: $state');
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}