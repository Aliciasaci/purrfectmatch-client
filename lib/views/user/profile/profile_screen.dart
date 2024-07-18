import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/views/user/profile/profile_menu_widget.dart';
import 'package:purrfectmatch/views/user/profile/edit_profile_screen.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../login.dart';
import 'settings_screen.dart';
import 'user_associations_screen.dart';

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
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            ApiService apiService = ApiService();
            User currentUser = state.user;
            String profilePictureURL = currentUser.profilePicURL! == "default"
                ? apiService.serveDefaultProfilePicture()
                : currentUser.profilePicURL!;

            return SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Column(
                children: [
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
                      child: Text(AppLocalizations.of(context)!.editProfile),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: AppLocalizations.of(context)!.settings,
                    icon: Icons.settings,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  ProfileMenuWidget(
                    title: AppLocalizations.of(context)!.associations,
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
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: AppLocalizations.of(context)!.createAssociation,
                    icon: Icons.verified,
                    onPress: () => Navigator.pushNamed(
                        context, '/user/create-association'),
                  ),
                  ProfileMenuWidget(
                    title: AppLocalizations.of(context)!.logout,
                    icon: Icons.logout,
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () => _logout(context),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text(AppLocalizations.of(context)!.userNotAuthenticated));
          }
        },
      ),
    );
  }
}
