import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/blocs/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      PlatformFile file = result.files.first;
      if (file.extension == 'pdf') {
        setState(() {
          _kbisFileName = file.name;
          _kbisFilePath = file.path;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectPdf)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noFileSelected)),
      );
    }
  }

  Future<void> _createAssociation() async {
    if (_formKey.currentState!.validate() && _kbisFilePath != null) {
      String ownerId = '';
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        ownerId = authState.user.id!;
        Association association = Association(
          Name: _nameController.text,
          AddressRue: _addressRueController.text,
          Cp: _cpController.text,
          Ville: _villeController.text,
          Phone: _phoneController.text,
          Email: _emailController.text,
          kbisFile: _kbisFilePath!,
          OwnerID: ownerId,
        );
        ApiService apiService = ApiService();

        try {
          await apiService.createAssociation(association, _kbisFilePath!, _kbisFileName!);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.associationCreatedSuccess)),
          );
          Navigator.pop(context, true);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppLocalizations.of(context)!.associationCreationError}: $e')),
          );
        }
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.fillAllFieldsAndChooseKbisFile)),
      );
    }
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {String? Function(String?)? validator}) {
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
          labelText: '$label *',
          border: InputBorder.none,
        ),
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return '${AppLocalizations.of(context)!.fillAllFieldsAndChooseKbisFile} $label';
          }
          return null;
        },
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '${AppLocalizations.of(context)!.fillAllFieldsAndChooseKbisFile} ${AppLocalizations.of(context)!.email}';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    return null;
  }

  String? _postalCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '${AppLocalizations.of(context)!.fillAllFieldsAndChooseKbisFile} ${AppLocalizations.of(context)!.postalCode}';
    }
    final postalCodeRegex = RegExp(r'^\d{5}$');
    if (!postalCodeRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidPostalCode;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createAssociation),
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
                      Text(
                        AppLocalizations.of(context)!.createAssociationProfile,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(_nameController, AppLocalizations.of(context)!.name),
                      const SizedBox(height: 15),
                      _buildTextFormField(_addressRueController, AppLocalizations.of(context)!.address),
                      const SizedBox(height: 15),
                      _buildTextFormField(_cpController, AppLocalizations.of(context)!.postalCode, validator: _postalCodeValidator),
                      const SizedBox(height: 15),
                      _buildTextFormField(_villeController, AppLocalizations.of(context)!.city),
                      const SizedBox(height: 15),
                      _buildTextFormField(_phoneController, AppLocalizations.of(context)!.phone),
                      const SizedBox(height: 15),
                      _buildTextFormField(_emailController, AppLocalizations.of(context)!.email, validator: _emailValidator),
                      const SizedBox(height: 15),
                      Text(
                        _kbisFileName ?? AppLocalizations.of(context)!.noFileChosen,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickKbisFile,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange[100],
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Text(AppLocalizations.of(context)!.chooseKbisFile),
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
                          child: Text(AppLocalizations.of(context)!.submit),
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
