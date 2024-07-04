import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/views/admin/drawer_navigation.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import 'blocs/crud_user_bloc.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CrudUserBloc(apiService: ApiService())..add(LoadUsers()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(title),
        ),
        drawer: const DrawerNavigation(),
        body: BlocBuilder<CrudUserBloc, CrudUserState>(
          builder: (context, state) {
            if (state is CrudUserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CrudUserLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nom')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Rôles')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: state.users.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(user.name)),
                      DataCell(Text(user.email)),
                      DataCell(Text(user.roles.map((role) => role.name).join(', ').toString())),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditUserDialog(context, user);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // BlocProvider.of<CrudUserBloc>(context).add(DeleteUser(user.id));
                              },
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              );
            } else if (state is CrudUserError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No users found'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddUserDialog(context),
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}

void _showAddUserDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ajouter un utilisateur'),
        content: const Text('Form'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // BlocProvider.of<CrudUserBloc>(context).add(CreateUser(user));
              Navigator.of(context).pop();
            },
            child: const Text('Valider'),
          ),
        ],
      );
    },
  );
}

void _showEditUserDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Modifier un utilisateur'),
        content: const Text('Form'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // BlocProvider.of<CrudUserBloc>(context).add(UpdateUser(user));
              Navigator.of(context).pop();
            },
            child: const Text('Valider'),
          ),
        ],
      );
    },
  );
}

void _showDeleteUserDialog(BuildContext context, int userId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Supprimer un utilisateur'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet utilisateur ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // BlocProvider.of<CrudUserBloc>(context).add(DeleteUser(userId));
              Navigator.of(context).pop();
            },
            child: const Text('Valider'),
          ),
        ],
      );
    },
  );
}
