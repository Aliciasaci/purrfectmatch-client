import 'package:flutter/material.dart';
import 'package:purrfectmatch/views/profile/profile_menu_widget.dart';
import 'package:purrfectmatch/constants/color.dart';
import 'package:purrfectmatch/constants/image_strings.dart';
import 'package:purrfectmatch/constants/text_strings.dart';
import 'package:purrfectmatch/views/profile/edit_profile_screen.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/models/user.dart';
import '../../services/auth_service.dart';
import '../login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

  class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _userUpdated;

  @override
  void initState() {
    super.initState();
    _userUpdated = ApiService().fetchCurrentUser();
  }

  void _logout() {
    AuthService().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(userProfileTitle,
              style: Theme.of(context).textTheme.headlineSmall),
          centerTitle: true,
        ),
        body: FutureBuilder<User>(
          future: _userUpdated,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              User currentUser = snapshot.data!;
              return SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 50.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: const Image(
                                        image: AssetImage(userProfileImage))),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.white),
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
                          currentUser == null
                              ? const CircularProgressIndicator()
                              : Column(
                            children: [
                              Text(currentUser.name,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headlineSmall),
                              Text(currentUser.email,
                                  style:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const EditProfileScreen()),
                                  ).then((_) {
                                    setState(() {
                                      _userUpdated =
                                          ApiService().fetchCurrentUser();
                                    });
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: darkYellowColor,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder()),
                                child: const Text(userEditProfileTitle,
                                    style: TextStyle(color: darkColor)),
                              )),
                          const SizedBox(height: 30),
                          const Divider(),
                          const SizedBox(height: 10),

                          /// MENU
                          ProfileMenuWidget(
                              title: "Réglages",
                              icon: Icons.settings,
                              onPress: () {}),
                          ProfileMenuWidget(
                              title: "Associations",
                              icon: Icons.other_houses,
                              onPress: () {}),
                          const Divider(),
                          const SizedBox(height: 10),
                          ProfileMenuWidget(
                              title: "Information",
                              icon: Icons.info_outline,
                              onPress: () {}),
                          ProfileMenuWidget(
                              title: "Se déconnecter",
                              icon: Icons.logout,
                              textColor: Colors.red,
                              endIcon: false,
                              onPress: _logout),
                        ],
                      )
                  )
              );
            }
          }
        )
    );
  }
}
