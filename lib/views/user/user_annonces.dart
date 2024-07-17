import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/annonce.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../annonce/edit_annonce_page.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../annonce/annonce_detail_page.dart';

class UserAnnoncesPage extends StatefulWidget {
  const UserAnnoncesPage({super.key});

  @override
  _UserAnnoncesPageState createState() => _UserAnnoncesPageState();
}

class _UserAnnoncesPageState extends State<UserAnnoncesPage> {
  List<Annonce> userAnnoncesData = [];
  Map<String, Cat> catsData = {};
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  bool _hasMore = true;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchUserAnnonces();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_loading &&
          _hasMore) {
        _fetchUserAnnonces();
      }
    });
  }

  Future<void> _fetchUserAnnonces() async {
    setState(() {
      _loading = true;
    });

    try {
      final apiService = ApiService();
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        final userId = authState.user.id;
        if (userId != null) {
          final newAnnonces = await apiService.fetchUserAnnonces(userId);

          for (var annonce in newAnnonces) {
            if (annonce.CatID != null) {
              final cat = await apiService.fetchCatByID(annonce.CatID);
              catsData[annonce.CatID!] = cat;
            }
          }

          setState(() {
            userAnnoncesData.addAll(newAnnonces);
            _loading = false;
            _hasMore = newAnnonces.isNotEmpty;
            _page++;
          });
        } else {
          setState(() {
            _loading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _deleteAnnonce(String annonceId) async {
    try {
      await ApiService().deleteAnnonce(annonceId);
      setState(() {
        userAnnoncesData
            .removeWhere((annonce) => annonce.ID.toString() == annonceId);
        _reloadUserAnnonces();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Annonce supprimée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors de la suppression de l\'annonce: $e')),
      );
    }
  }

  void _reloadUserAnnonces() async {
    setState(() {
      userAnnoncesData.clear();
      catsData.clear();
      _page = 1;
      _hasMore = true;
    });
    await _fetchUserAnnonces();
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
        title: Text(AppLocalizations.of(context)!.myAnnouncements),
        backgroundColor: Colors.orange[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[100]!, Colors.orange[200]!],
          ),
        ),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: userAnnoncesData.length + 1,
          itemBuilder: (context, index) {
            if (index == userAnnoncesData.length) {
              return _loading
                  ? const Center(child: CircularProgressIndicator())
                  : !_hasMore
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('No more annonces')),
                        )
                      : const SizedBox.shrink();
            }
            final annonce = userAnnoncesData[index];
            final cat = annonce.CatID != null ? catsData[annonce.CatID] : null;
            return Card(
              margin: const EdgeInsets.all(10),
              color: Colors.white,
              child: ListTile(
                leading: cat != null && cat.picturesUrl.isNotEmpty
                    ? Image.network(
                        cat.picturesUrl.first,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image, size: 50, color: Colors.orange),
                title: Text(annonce.Title),
                subtitle: Text(
                  'Description: ${annonce.Description}\nChat: ${cat?.name ?? 'Unknown'}',
                ),
                trailing: Wrap(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditAnnoncePage(annonce: annonce),
                          ),
                        ).then((value) {
                          if (value == true) {
                            _reloadUserAnnonces();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.orange),
                      onPressed: () {
                        if (annonce.ID != null) {
                          _deleteAnnonce(annonce.ID.toString());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ID de l\'annonce invalide'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnnonceDetailPage(annonce: annonce),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
