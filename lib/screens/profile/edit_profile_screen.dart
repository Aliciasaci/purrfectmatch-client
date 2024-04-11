import 'package:flutter/material.dart';
import 'package:purrfectmatch/constants/color.dart';
import 'package:purrfectmatch/constants/image_strings.dart';
import 'package:purrfectmatch/constants/text_strings.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userEditProfileTitle, style: Theme.of(context).textTheme.headlineSmall),
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
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(image: AssetImage(userProfileImage))
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 20
                      )
                    ))
                ],
              ),
              const SizedBox(height: 50),

              Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Name",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Firstname",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email)
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          prefixIcon: Icon(Icons.phone)
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.password),
                          // suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), onPressed),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () { },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkYellowColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(userEditProfileTitle, style: TextStyle(color: darkColor)),
                        )
                      ),

                      const SizedBox(height: 50),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text.rich(
                            TextSpan(
                              text: "Joined",
                              style: TextStyle(fontSize: 12),
                              children: [
                                TextSpan(
                                    text: " 19/09/2023",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent.withOpacity(0.1),
                                elevation: 0,
                                foregroundColor: Colors.red,
                                shape: const StadiumBorder(),
                                side: BorderSide.none),
                            child: const Text(userDeleteProfile),
                          ),
                        ],
                      )
                    ],
                  )
              )
            ]
          )
        )
      )
    );
  }
}
