import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/views/user/profile/profile_menu_widget.dart';
import 'package:purrfectmatch/constants/image_strings.dart';
import 'package:purrfectmatch/models/user.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../login.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';  // Add this line to import the SettingsScreen

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
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            User currentUser = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Image(image: AssetImage(userProfileImage)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 20,
                          ),
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Editer mon profil'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: "Réglages",
                    icon: Icons.settings,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  ProfileMenuWidget(
                    title: "Associations",
                    icon: Icons.home,
                    onPress: () {},
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: "Créer Association",
                    icon: Icons.verified,
                    onPress: () => Navigator.pushNamed(context, '/user/create-association'),
                  ),
                  ProfileMenuWidget(
                    title: "Se déconnecter",
                    icon: Icons.logout,
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () => _logout(context),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('User not authenticated'));
          }
        },
      ),
    );
  }
}
