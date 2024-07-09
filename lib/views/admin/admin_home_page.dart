import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/views/admin/drawer_navigation.dart';
import '../../services/api_service.dart';
import 'blocs/crud_user_bloc.dart';
import 'crud_user_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: const DrawerNavigation(),
      body: const Center(child: Text('Bienvenue sur la page d\'accueil de l\'administrateur')),
    );
  }
}
