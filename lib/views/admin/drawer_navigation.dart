import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../services/api_service.dart';
import '../login.dart';
import 'featureflag/blocs/featureflag_bloc.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Tableau de bord'),
          ),
          ListTile(
            title: const Text('Gestion des utilisateurs'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/users');
            },
          ),
          ListTile(
            title: const Text('Gestion des races'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/races');
            },
          ),
          ListTile(
            title: const Text('Gestion des demandes d\'association'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/associations');
            },
          ),
          ListTile(
            title: const Text('Gestion des reports'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/reports');
            },
          ),
          ListTile(
            title: const Text('Feature Flags'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/feature-flags');
            },
          ),
          ListTile(
            title: const Text('Déconnexion'),
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<FeatureFlagBloc>(
                    create: (context) =>
                        FeatureFlagBloc(apiService: ApiService())
                          ..add(LoadFeatureFlags()),
                    child: const LoginPage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
