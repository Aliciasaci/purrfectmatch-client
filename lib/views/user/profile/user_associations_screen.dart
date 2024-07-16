import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/blocs/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'edit_association_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchUserAssociations();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !_loading &&
          _hasMore) {
        _fetchUserAssociations();
      }
    });
  }

  Future<void> _fetchUserAssociations() async {
    setState(() {
      _loading = true;
    });

    try {
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        final userId = authState.user.id;
        if (userId != null) {
          final newAssociations = await _apiService.fetchUserAssociations(userId);
          setState(() {
            _associations.addAll(newAssociations);
            _loading = false;
            _hasMore = newAssociations.isNotEmpty;
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
      print('Erreur lors du chargement des associations: $e');
    }
  }

  Future<void> _deleteAssociation(String associationId) async {
    try {
      await _apiService.deleteAssociation(associationId);
      setState(() {
        _associations.removeWhere((association) => association.id.toString() == associationId);
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

  Future<Widget> _buildMemberList(Association association) async {
    List<Widget> memberWidgets = [];
    List<String> memberIds = association.members;

    for (String memberId in memberIds) {
      memberId = memberId.replaceAll(RegExp(r'[\[\]"]'), ''); // Clean up the ID
      bool isOwner = memberId == association.ownerId;
      try {
        User user = await _apiService.fetchUserByID(memberId);
        memberWidgets.add(
          ListTile(
            leading: isOwner
                ? const Icon(Icons.verified_user, color: Colors.orange)
                : null,
            title: Text('${user.name}${isOwner ? ' (Owner)' : ''}'),
            subtitle: Text(user.email),
          ),
        );
      } catch (e) {
        memberWidgets.add(
          ListTile(
            leading: isOwner
                ? const Icon(Icons.verified_user, color: Colors.orange)
                : null,
            title: Text('ID: $memberId'),
            subtitle: const Text('Failed to load user details'),
          ),
        );
      }
    }
    return Column(children: memberWidgets);
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
            return Card(
              margin: const EdgeInsets.all(10),
              color: Colors.white,
              child: ListTile(
                title: Text(
                  association.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: ${association.email}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Address: ${association.addressRue}, ${association.cp} ${association.ville}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Membres',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    FutureBuilder<Widget>(
                      future: _buildMemberList(association),
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
                  ],
                ),
                trailing: Wrap(
                  spacing: 12, // space between two icons
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
                        if (association.id != null) {
                          _deleteAssociation(association.id.toString());
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
              ),
            );
          },
        ),
      ),
    );
  }
}
