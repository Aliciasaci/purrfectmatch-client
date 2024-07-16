import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/constants/color.dart';
import 'package:purrfectmatch/constants/image_strings.dart';
import 'package:purrfectmatch/constants/text_strings.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../models/user.dart';

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
  String _profilePicController = "";
  final ApiService apiService = ApiService();

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
  }

  void _initializeCurrentUser() {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      _currentUser = authState.user;
      _nameController.text = _currentUser!.name;
      _emailController.text = _currentUser!.email;
      _addressRueController.text = _currentUser!.addressRue;
      _cpController.text = _currentUser!.cp;
      _villeController.text = _currentUser!.ville;
      _profilePicController = _currentUser!.profilePicURL! == "default"
          ? apiService.serveDefaultProfilePicture()
          : _currentUser!.profilePicURL!;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      final image = await apiService.updateUserProfilePic(_currentUser!.id!,
          pickedFile.files.single.path!, pickedFile.files.single.name);
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        _profilePicController = image;
      });
      final updatedUser = _currentUser!.copyWith(profilePicURL: image);
      // Use a local variable for BlocProvider to avoid using context across async gaps
      final authBloc = BlocProvider.of<AuthBloc>(context);
      if (!mounted) return; // Check again as there's another async gap before
      authBloc.add(UpdateProfilePicRequested(updatedUser));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressRueController.dispose();
    _cpController.dispose();
    _villeController.dispose();
    _profilePicController = "";
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

    BlocProvider.of<AuthBloc>(context).add(UpdateProfileRequested(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userEditProfileTitle,
            style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            setState(() {
              _currentUser = state.user;
              _nameController.text = _currentUser!.name;
              _emailController.text = _currentUser!.email;
              _addressRueController.text = _currentUser!.addressRue;
              _cpController.text = _currentUser!.cp;
              _villeController.text = _currentUser!.ville;
              _profilePicController = _currentUser!.profilePicURL! == "default"
                  ? apiService.serveDefaultProfilePicture()
                  : _currentUser!.profilePicURL!;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Profile updated successfully"),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: SingleChildScrollView(
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
                      child: Image.network(_profilePicController),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
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
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange[100]!,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Nom",
                          prefixIcon:
                              Icon(Icons.person, color: Colors.orange[100]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange[100]!,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Mail",
                          prefixIcon:
                              Icon(Icons.email, color: Colors.orange[100]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange[100]!,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _addressRueController,
                        decoration: InputDecoration(
                          labelText: "Adresse rue",
                          prefixIcon:
                              Icon(Icons.home, color: Colors.orange[100]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange[100]!,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _cpController,
                        decoration: InputDecoration(
                          labelText: "CP",
                          prefixIcon:
                              Icon(Icons.home, color: Colors.orange[100]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange[100]!,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _villeController,
                        decoration: InputDecoration(
                          labelText: "Ville",
                          prefixIcon:
                              Icon(Icons.home, color: Colors.orange[100]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: _updateUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[100],
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(userEditProfileTitle)),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Joined",
                            style: const TextStyle(fontSize: 12),
                            children: [
                              TextSpan(
                                text: " ${_currentUser?.createdAt ?? ''}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
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
}
