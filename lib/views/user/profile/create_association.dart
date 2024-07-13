import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/services/api_service.dart';

import '../../../blocs/auth/auth_bloc.dart';

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
      String ownerId = '';
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        ownerId = authState.user.id!;
        Association association = Association(
          name: _nameController.text,
          addressRue: _addressRueController.text,
          cp: _cpController.text,
          ville: _villeController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          kbisFile: _kbisFilePath!,
          ownerId: ownerId,
        );
        ApiService apiService = ApiService();
        try {
          await apiService.createAssociation(association, _kbisFilePath!, _kbisFileName!);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('L\'association a été créée avec succès')),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la création de l\'association')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Créer Association'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le nom de l\'association';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _addressRueController,
              decoration: const InputDecoration(labelText: 'Adresse', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer l\'adresse de l\'association';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _cpController,
              decoration: const InputDecoration(labelText: 'Code Postal', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le code postal de l\'association';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _villeController,
              decoration: const InputDecoration(labelText: 'Ville', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la ville de l\'association';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le téléphone de l\'association';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer l\'email de l\'association';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            Text(
              _kbisFileName ?? 'Aucun fichier choisi',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            ElevatedButton(
              onPressed: _pickKbisFile,
              child: const Text('Choisir le fichier KBIS'),
            ),
            ElevatedButton(
              onPressed: _createAssociation,
              child: const Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
