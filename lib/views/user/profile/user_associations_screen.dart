import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/association.dart';
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
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
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
          final newAssociations =
          await _apiService.fetchUserAssociations(userId);
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
    }
  }

  Future<void> _deleteAssociation(String associationId) async {
    try {
      await _apiService.deleteAssociation(associationId);
      setState(() {
        _associations.removeWhere(
                (association) => association.id.toString() == associationId);
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
        child: ListView.builder(
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
                title: Text(association.name),
                subtitle: Text('Email: ${association.email}\nAddress: ${association.addressRue}, ${association.cp} ${association.ville}'),
                trailing: Wrap(
                  children: [
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
