import 'package:flutter/material.dart';
import 'package:purrfectmatch/constants/color.dart';
import 'package:purrfectmatch/constants/image_strings.dart';
import 'package:purrfectmatch/constants/text_strings.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressRueController = TextEditingController();
  final _cpController = TextEditingController();
  final _villeController = TextEditingController();

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    ApiService().fetchCurrentUser().then((user) {
      setState(() {
        _currentUser = user;
        _nameController.text = _currentUser!.name;
        _emailController.text = _currentUser!.email;
        _addressRueController.text = _currentUser!.addressRue;
        _cpController.text = _currentUser!.cp;
        _villeController.text = _currentUser!.ville;
      });
    }).catchError((error) {
      print('Error fetching user data: $error');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressRueController.dispose();
    _cpController.dispose();
    _villeController.dispose();
    super.dispose();
  }

  void _updateUser() {
    final updatedUser = User(
      id: _currentUser!.id,
      name: _nameController.text,
      email: _emailController.text,
      addressRue: _addressRueController.text,
      cp: _cpController.text,
      ville: _villeController.text,
    );

    ApiService().updateUser(updatedUser).then((_) {
      print('User data updated');
      final snackBar = SnackBar(
        content: const Text('Profil mis à jour avec succès !'),
        action: SnackBarAction(
          label: 'Fermer',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((error) {
      print('Error updating user data: $error');
      final snackBar = SnackBar(
        content: Text("Une erreur s'est produite.: $error"),
        action: SnackBarAction(
          label: 'Fermer',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Nom",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Mail",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _addressRueController,
                        decoration: const InputDecoration(
                          labelText: "Adresse rue",
                          prefixIcon: Icon(Icons.home),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _cpController,
                        decoration: const InputDecoration(
                          labelText: "CP",
                          prefixIcon: Icon(Icons.home),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _villeController,
                        decoration: const InputDecoration(
                          labelText: "Ville",
                          prefixIcon: Icon(Icons.home),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _updateUser,
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
