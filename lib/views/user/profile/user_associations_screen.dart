import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/blocs/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'edit_association_screen.dart';
import 'association_detail_screen.dart';

class UserAssociationsScreen extends StatefulWidget {
  const UserAssociationsScreen({super.key});

  @override
  State<UserAssociationsScreen> createState() => _UserAssociationsScreenState();
}

class _UserAssociationsScreenState extends State<UserAssociationsScreen> {
  final ApiService _apiService = ApiService();
  List<Association> _associations = [];
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  bool _hasMore = true;
  int _page = 1;
  User? currentUser;

  @override
  void initState() {
    print("ici");
    super.initState();
    _loadCurrentUser().then((_) {
      print(currentUser);
      if (currentUser != null) {
        _fetchUserAssociations();
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !_loading &&
          _hasMore) {
        _fetchUserAssociations();
      }
    });
  }

  Future<void> _loadCurrentUser() async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      setState(() {
        currentUser = authState.user;
      });
      print("Utilisateur actuel chargé : ${currentUser?.toJson()}");
    } else {
      print("Utilisateur non authentifié");
    }
  }

  Future<void> _fetchUserAssociations() async {
    if (currentUser == null) {
      print("Utilisateur non chargé, annulation de la récupération des associations");
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      print("Récupération des associations pour l'utilisateur : ${currentUser!.id}");
      final newAssociations = await _apiService.fetchUserAssociations(currentUser!.id!);

      setState(() {
        _associations.addAll(newAssociations);
        _loading = false;
        _hasMore = newAssociations.isNotEmpty;
        _page++;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Erreur lors du chargement des associations: $e');
    }
  }

  Future<void> _deleteAssociation(String associationId) async {
    try {
      await _apiService.deleteAssociation(associationId);
      setState(() {
        _associations.removeWhere((association) => association.ID.toString() == associationId);
        _reloadUserAssociations();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Association supprimée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression de l\'association: $e')),
      );
    }
  }

  void _reloadUserAssociations() async {
    setState(() {
      _associations.clear();
      _page = 1;
      _hasMore = true;
    });
    await _fetchUserAssociations();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Widget> _buildOwnerInfo(Association association) async {
    try {
      User owner = await _apiService.fetchUserByID(association.OwnerID);
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user, color: Colors.orange),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${owner.name} (Propriétaire)'),
                Text(owner.email),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user, color: Colors.orange),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${association.OwnerID}'),
                const Text('Failed to load owner details'),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myAssociations),
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
        child: _loading && _associations.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          controller: _scrollController,
          itemCount: _associations.length + 1,
          itemBuilder: (context, index) {
            if (index == _associations.length) {
              return _loading
                  ? const Center(child: CircularProgressIndicator())
                  : !_hasMore
                  ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('No more associations')),
              )
                  : const SizedBox.shrink();
            }
            final association = _associations[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssociationDetailScreen(association: association),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        association.Name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email de contact: ${association.Email}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Adresse de l\'association: ${association.AddressRue}, ${association.Cp} ${association.Ville}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<Widget>(
                        future: _buildOwnerInfo(association),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return ListTile(
                              title: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return snapshot.data ?? Container();
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      if (currentUser?.id == association.OwnerID)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditAssociationScreen(association: association),
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    _reloadUserAssociations();
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.orange),
                              onPressed: () {
                                if (association.ID != null) {
                                  _deleteAssociation(association.ID.toString());
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('ID de l\'association invalide'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
