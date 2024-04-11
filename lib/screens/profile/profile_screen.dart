import 'package:flutter/material.dart';
import 'package:purrfectmatch/composants/profile_menu_widget.dart';
import 'package:purrfectmatch/constants/color.dart';
import 'package:purrfectmatch/constants/image_strings.dart';
import 'package:purrfectmatch/constants/text_strings.dart';
import 'package:purrfectmatch/screens/profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userProfileTitle, style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100), child: const Image(image: AssetImage(userProfileImage))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
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
                Text("User 1", style: Theme.of(context).textTheme.headlineSmall),
                Text("user1@gmail.com", style: Theme.of(context).textTheme.bodyMedium),
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
                      backgroundColor: darkYellowColor, side: BorderSide.none, shape: const StadiumBorder()
                    ),
                    child: const Text(userEditProfileTitle, style: TextStyle(color: darkColor)),
                  )
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),

                /// MENU
                ProfileMenuWidget(title: "Settings", icon: Icons.settings, onPress: () { }),
                ProfileMenuWidget(title: "Associations", icon: Icons.other_houses, onPress: () { }),
                const Divider(),
                const SizedBox(height: 10),
                ProfileMenuWidget(title: "Information", icon: Icons.info_outline, onPress: () { }),
                ProfileMenuWidget(
                    title: "Logout",
                    icon: Icons.logout,
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () { }),
              ],
            )
          )
        )
    );
  }
}
