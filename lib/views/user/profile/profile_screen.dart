import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/views/user/profile/profile_menu_widget.dart';
import 'package:purrfectmatch/views/user/profile/settings_screen.dart';
import 'package:purrfectmatch/views/user/profile/user_associations_screen.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';
import '../../admin/featureflag/blocs/featureflag_bloc.dart';
import '../../login.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _logout(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<FeatureFlagBloc>(
          create: (context) => FeatureFlagBloc(apiService: ApiService())..add(LoadFeatureFlags()),
          child: const LoginPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeatureFlagBloc, FeatureFlagState>(
      builder: (context, featureFlagState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is AuthAuthenticated) {
                ApiService apiService = ApiService();
                User currentUser = authState.user;
                String profilePictureURL = currentUser.profilePicURL! == "default"
                    ? apiService.serveDefaultProfilePicture()
                    : currentUser.profilePicURL!;

                var widgets = <Widget>[
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(profilePictureURL),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(currentUser.name,
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text(currentUser.email,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfileScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[100],
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Editer mon profil'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: "Réglages",
                    icon: Icons.settings,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ];

                if (featureFlagState is FeatureFlagLoaded) {
                  final associationEnabled = featureFlagState.featureFlags
                      .firstWhere((flag) => flag.name == 'Association')
                      .isEnabled;

                  if (associationEnabled) {
                    widgets.addAll([
                      ProfileMenuWidget(
                        title: "Associations",
                        icon: Icons.home,
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const UserAssociationsScreen()),
                          );
                        },
                      ),
                      ProfileMenuWidget(
                        title: "Créer Association",
                        icon: Icons.verified,
                        onPress: () => Navigator.pushNamed(
                            context, '/user/create-association'),
                      ),
                    ]);
                  }
                }

                widgets.addAll([
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: "Se déconnecter",
                    icon: Icons.logout,
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () => _logout(context),
                  ),
                ]);

                return SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Column(children: widgets),
                );
              } else {
                return const Center(child: Text('User not authenticated'));
              }
            },
          ),
        );
      },
    );
  }
}