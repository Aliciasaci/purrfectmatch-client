import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/blocs/auth/auth_bloc.dart';

class CreateAssociation extends StatefulWidget {
  const CreateAssociation({super.key});

  @override
  State<CreateAssociation> createState() => _CreateAssociationState();
}

class _CreateAssociationState extends State<CreateAssociation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressRueController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _kbisFileName;
  String? _kbisFilePath;

  Future<void> _pickKbisFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _kbisFileName = result.files.single.name;
        _kbisFilePath = result.files.single.path;
      });
    }
  }

  Future<void> _createAssociation() async {
    if (_formKey.currentState!.validate() && _kbisFilePath != null) {
      String OwnerID = '';
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        OwnerID = authState.user.id!;
        Association association = Association(
          Name: _nameController.text,
          AddressRue: _addressRueController.text,
          Cp: _cpController.text,
          Ville: _villeController.text,
          Phone: _phoneController.text,
          Email: _emailController.text,
          kbisFile: _kbisFilePath!,
          OwnerID: OwnerID,
        );
        ApiService apiService = ApiService();

        // Afficher l'objet association dans la console
        print('Association created: ${association.toJson()}');

        try {
          await apiService.createAssociation(association, _kbisFilePath!, _kbisFileName!);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('L\'association a été créée avec succès')),
          );
          Navigator.pop(context, true);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la création de l\'association: $e')),
          );
        }
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs et choisir un fichier KBIS')),
      );
    }
  }

  Widget _buildTextFormField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange[100]!,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer $label de l\'association';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer Association'),
        backgroundColor: Colors.orange[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[100]!, Colors.orange[200]!],
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Créer le profil de l\'association',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(_nameController, 'Nom'),
                      const SizedBox(height: 15),
                      _buildTextFormField(_addressRueController, 'Adresse'),
                      const SizedBox(height: 15),
                      _buildTextFormField(_cpController, 'Code Postal'),
                      const SizedBox(height: 15),
                      _buildTextFormField(_villeController, 'Ville'),
                      const SizedBox(height: 15),
                      _buildTextFormField(_phoneController, 'Téléphone'),
                      const SizedBox(height: 15),
                      _buildTextFormField(_emailController, 'Email'),
                      const SizedBox(height: 15),
                      Text(
                        _kbisFileName ?? 'Aucun fichier choisi',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickKbisFile,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange[100],
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Text('Choisir le fichier KBIS'),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: _createAssociation,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange[100],
                            padding: const EdgeInsets.all(15),
                          ),
                          child: const Text('Valider'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
