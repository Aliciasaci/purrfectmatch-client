import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import '../../models/role.dart';
import '../../models/user.dart';
import 'blocs/crud_user_bloc.dart';

class CrudUserPage extends StatelessWidget {
  const CrudUserPage({super.key});

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Color getRoleColor(String roleName) {
    switch (roleName) {
      case 'ADMIN':
        return Colors.red.shade100;
      case 'USER':
        return Colors.green.shade100;
      case 'ASSO':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Gestion des utilisateurs'),
      ),
      body: BlocConsumer<CrudUserBloc, CrudUserState>(
        listener: (context, state) {
          if (state is CrudUserCreated) {
            showSnackBar(context, 'L\'utilisateur a été créé avec succès.');
          } else if (state is CrudUserUpdated) {
            showSnackBar(context, 'L\'utilisateur a été mis à jour avec succès.');
          } else if (state is CrudUserDeleted) {
            showSnackBar(context, 'L\'utilisateur a été supprimé avec succès.');
          }
        },
        builder: (context, state) {
          if (state is CrudUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CrudUserLoaded) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                              DataCell(
                                Row(
                                  children: user.roles.map((role) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 4.0),
                                      child: badges.Badge(
                                        badgeContent: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                          child: Text(
                                            role.name,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        badgeStyle: badges.BadgeStyle(
                                          badgeColor: getRoleColor(role.name),
                                          shape: badges.BadgeShape.square,
                                          borderRadius: BorderRadius.circular(4),
                                          padding: const EdgeInsets.all(0),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        CrudUserModalBottomSheets.showEditUserModalBottomSheet(context, user);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        CrudUserModalBottomSheets.showDeleteUserModalBottomSheet(context, user.id!);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is CrudUserError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Aucun utilisateur trouvé.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CrudUserModalBottomSheets.showAddUserModalBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CrudUserModalBottomSheets {
  static void showAddUserModalBottomSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController addressRueController = TextEditingController();
    final TextEditingController cpController = TextEditingController();
    final TextEditingController villeController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String? selectedRole;

    final CrudUserBloc crudUserBloc = BlocProvider.of<CrudUserBloc>(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Ajouter un utilisateur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Form(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: addressRueController,
                                decoration: const InputDecoration(labelText: 'Adresse rue', border: OutlineInputBorder()),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: cpController,
                                decoration: const InputDecoration(labelText: 'CP', border: OutlineInputBorder()),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: villeController,
                                decoration: const InputDecoration(labelText: 'Ville', border: OutlineInputBorder()),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: passwordController,
                                decoration: const InputDecoration(labelText: 'Mot de passe', border: OutlineInputBorder()),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField(
                                items: const [
                                  DropdownMenuItem(value: 'ADMIN', child: Text('ADMIN')),
                                  DropdownMenuItem(value: 'USER', child: Text('USER')),
                                  DropdownMenuItem(value: 'ASSO', child: Text('ASSO')),
                                ],
                                decoration: const InputDecoration(labelText: 'Sélectionner un rôle', border: OutlineInputBorder()),
                                onChanged: (value) {
                                  setState(() {
                                    selectedRole = value;
                                  });
                                },
                                value: selectedRole,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final User newUser = User(
                                        name: nameController.text,
                                        email: emailController.text,
                                        addressRue: addressRueController.text,
                                        cp: cpController.text,
                                        ville: villeController.text,
                                        password: passwordController.text,
                                        roles: [Role(name: selectedRole ?? '')],
                                      );
                                      crudUserBloc.add(CreateUser(newUser));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Valider'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        );
      },
    );
  }

  static void showEditUserModalBottomSheet(BuildContext context, User user) {
    final TextEditingController nameController = TextEditingController(text: user.name);
    final TextEditingController emailController = TextEditingController(text: user.email);
    final TextEditingController addressRueController = TextEditingController(text: user.addressRue);
    final TextEditingController cpController = TextEditingController(text: user.cp);
    final TextEditingController villeController = TextEditingController(text: user.ville);
    String? selectedRole = user.roles.isNotEmpty ? user.roles[0].name : null;

    final CrudUserBloc crudUserBloc = BlocProvider.of<CrudUserBloc>(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Modifier un utilisateur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: addressRueController,
                          decoration: const InputDecoration(labelText: 'Adresse rue', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: cpController,
                          decoration: const InputDecoration(labelText: 'CP', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: villeController,
                          decoration: const InputDecoration(labelText: 'Ville', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField(
                          value: selectedRole,
                          items: const [
                            DropdownMenuItem(value: 'ADMIN', child: Text('ADMIN')),
                            DropdownMenuItem(value: 'USER', child: Text('USER')),
                            DropdownMenuItem(value: 'ASSO', child: Text('ASSO')),
                          ],
                          decoration: const InputDecoration(labelText: 'Sélectionner un rôle', border: OutlineInputBorder()),
                          onChanged: (value) {
                            selectedRole = value;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () {
                                final User updatedUser = User(
                                  id: user.id,
                                  name: nameController.text,
                                  email: emailController.text,
                                  addressRue: addressRueController.text,
                                  cp: cpController.text,
                                  ville: villeController.text,
                                  roles: [Role(name: selectedRole ?? '')],
                                );
                                crudUserBloc.add(UpdateUser(updatedUser));
                                Navigator.of(context).pop();
                              },
                              child: const Text('Valider'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showDeleteUserModalBottomSheet(BuildContext context, String userId) {
    final CrudUserBloc crudUserBloc = BlocProvider.of<CrudUserBloc>(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Supprimer un utilisateur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Êtes-vous sûr de vouloir supprimer cet utilisateur ?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      crudUserBloc.add(DeleteUser(userId));
                      Navigator.of(context).pop();
                    },
                    child: const Text('Valider'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
