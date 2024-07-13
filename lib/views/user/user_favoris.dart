import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/favoris.dart';
import '../../models/annonce.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../annonce/annonce_detail_page.dart';
import '../cat/chat_page.dart';
import '../../blocs/auth/auth_bloc.dart';

class UserFavorisPage extends StatefulWidget {
  const UserFavorisPage({super.key});

  @override
  _UserFavorisPageState createState() => _UserFavorisPageState();
}

class _UserFavorisPageState extends State<UserFavorisPage> {
  List<Favoris> userFavorisData = [];
  Map<String, Annonce> annoncesData = {};
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
          for (var favori in newFavoris) {
            final annonce = await apiService.fetchAnnonceByID(favori.AnnonceID);
            annoncesData[favori.AnnonceID] = annonce;
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes favoris'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amberAccent[100]!, Colors.orange[400]!],
          ),
        ),
        child: ListView.builder(
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
                        future: ApiService().fetchCatByID(annonce.CatID!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Icon(Icons.error);
                          } else if (!snapshot.hasData ||
                              snapshot.data!.picturesUrl.isEmpty) {
                            return const Icon(Icons.image);
                          } else {
                            return Image.network(
                                snapshot.data!.picturesUrl.first,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover);
                          }
                        },
                      )
                    : const Icon(Icons.image, size: 50),
                title: Text(annonce != null
                    ? annonce.Title
                    : 'Annonce ID: ${favori.AnnonceID}'),
                subtitle: Text(annonce != null
                    ? annonce.Description
                    : 'User ID: ${favori.UserID}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chat),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(userId: favori.UserID),
                          ),
                        );
                      },
                    ),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
                onTap: () {
                  if (annonce != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AnnonceDetailPage(annonce: annonce),
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
