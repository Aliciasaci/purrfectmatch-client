import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/room.dart';
import 'package:purrfectmatch/views/user/room/room_screen.dart';
import '../../models/favoris.dart';
import '../../models/annonce.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../annonce/annonce_detail_page.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserFavorisPage extends StatefulWidget {
  const UserFavorisPage({super.key});

  @override
  _UserFavorisPageState createState() => _UserFavorisPageState();
}

class _UserFavorisPageState extends State<UserFavorisPage> {
  List<Favoris> userFavorisData = [];
  Map<String, Annonce> annoncesData = {};
  Map<String, Room> roomsData = {};
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserFavoris();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_loading) {
        _fetchUserFavoris();
      }
    });
  }

  Future<void> _fetchUserFavoris() async {
    setState(() {
      _loading = true;
    });

    try {
      final apiService = ApiService();
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        final userId = authState.user.id;
        if (userId != null) {
          final newFavoris = await apiService.fetchUserFavorites(userId);
          final userRooms = await apiService.getUserRooms();
          for (var favori in newFavoris) {
            final annonce = await apiService.fetchAnnonceByID(favori.AnnonceID);
            annoncesData[favori.AnnonceID] = annonce;
            int annonceIDToInt = int.parse(favori.AnnonceID);
            final room = userRooms.firstWhere(
              (room) => room.annonceID == annonceIDToInt,
            );
            roomsData[favori.AnnonceID] = room;
          }
          setState(() {
            userFavorisData.addAll(newFavoris);
            _loading = false;
          });
        } else {
          setState(() {
            _loading = false;
          });
          print('User ID is null');
        }
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Failed to load user favorites: $e');
    }
  }

  Future<void> _deleteFavori(String favoriId) async {
    try {
      await ApiService().deleteAnnonce(favoriId);
      setState(() {
        userFavorisData.removeWhere((favori) => favori.AnnonceID == favoriId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Favori supprimé avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du favori: $e')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myFavorites),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: userFavorisData.length + 1,
        itemBuilder: (context, index) {
          if (index == userFavorisData.length) {
            return _loading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          }
          final favori = userFavorisData[index];
          final annonce = annoncesData[favori.AnnonceID];
          return Card(
            margin: const EdgeInsets.all(10),
            color: Colors.white,
            child: ListTile(
              leading: annonce != null && annonce.CatID != null
                  ? FutureBuilder<Cat>(
                      future: ApiService().fetchCatByID(annonce.CatID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error, color: Colors.orange[100]);
                        } else if (!snapshot.hasData ||
                            snapshot.data!.picturesUrl.isEmpty) {
                          return Icon(Icons.image, color: Colors.orange[100]);
                        } else {
                          return Image.network(snapshot.data!.picturesUrl.first,
                              width: 50, height: 50, fit: BoxFit.cover);
                        }
                      },
                    )
                  : Icon(Icons.image, size: 50, color: Colors.orange[100]),
              title: Text(annonce != null
                  ? annonce.Title
                  : 'Annonce ID: ${favori.AnnonceID}'),
              subtitle: Text(annonce != null
                  ? annonce.Description
                  : 'User ID: ${favori.UserID}'),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: Icon(Icons.chat, color: Colors.orange[100]),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomScreen(
                            roomID: roomsData[favori.AnnonceID]!.id!,
                            room: roomsData[favori.AnnonceID]!,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.orange[100]),
                    onPressed: () {
                      _deleteFavori(favori.AnnonceID);
                    },
                  ),
                ],
              ),
              onTap: () {
                if (annonce != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnnonceDetailPage(annonce: annonce),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
