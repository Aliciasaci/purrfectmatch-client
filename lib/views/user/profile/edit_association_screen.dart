import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/blocs/auth/auth_bloc.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditAssociationScreen extends StatefulWidget {
  final Association association;

  const EditAssociationScreen({super.key, required this.association});

  @override
  State<EditAssociationScreen> createState() => _EditAssociationScreenState();
}

class _EditAssociationScreenState extends State<EditAssociationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  PlatformFile? _selectedFile;
  late ApiService _apiService;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _populateFields();
  }

  void _populateFields() {
    _nameController.text = widget.association.name;
    _addressController.text = widget.association.addressRue;
    _cpController.text = widget.association.cp;
    _villeController.text = widget.association.ville;
    _phoneController.text = widget.association.phone;
    _emailController.text = widget.association.email;
    _isVerified = widget.association.verified ?? false;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });

      print('File selected: ${_selectedFile!.name}');
      print('File path: ${_selectedFile!.path}');
      print('File size: ${_selectedFile!.size}');
      print('File readStream: ${_selectedFile!.readStream != null ? 'Available' : 'Not available'}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> _saveChanges() async {
    Association updatedAssociation = widget.association.copyWith(
      name: _nameController.text,
      addressRue: _addressController.text,
      cp: _cpController.text,
      ville: _villeController.text,
      phone: _phoneController.text,
      email: _emailController.text,
    );

    try {
      await _apiService.updateAssociation(updatedAssociation);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Association updated successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update association: $e')),
      );
    }
  }

  Future<void> _updateVerifyStatus(bool isVerified) async {
    try {
      await _apiService.updateAssociationVerifyStatus(widget.association.id!, isVerified);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Association verification status updated')),
      );
      setState(() {
        _isVerified = isVerified;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update verification status: $e')),
      );
    }
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {bool readOnly = false, void Function()? onTap, Icon? suffixIcon}) {
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
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Association'),
        backgroundColor: Colors.orange[100],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[100]!, Colors.orange[200]!],
          ),
        ),
        child: Center(
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      if (_selectedFile != null)
                        Center(
                          child: Image.file(
                            File(_selectedFile!.path!),
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 10),
                      _buildTextFormField(_nameController, 'Name'),
                      const SizedBox(height: 10),
                      _buildTextFormField(_addressController, 'Address'),
                      const SizedBox(height: 10),
                      _buildTextFormField(_cpController, 'CP'),
                      const SizedBox(height: 10),
                      _buildTextFormField(_villeController, 'Ville'),
                      const SizedBox(height: 10),
                      _buildTextFormField(_phoneController, 'Phone'),
                      const SizedBox(height: 10),
                      _buildTextFormField(_emailController, 'Email'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: Text(
                          _selectedFile == null ? 'Select PDF' : 'PDF Selected: ${_selectedFile!.name}',
                        ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[100],
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text('Save Changes'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SwitchListTile(
                        title: const Text('Verified'),
                        value: _isVerified,
                        onChanged: (bool value) {
                          _updateVerifyStatus(value);
                        },
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
