import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/blocs/auth/auth_bloc.dart';

class EditAssociationScreen extends StatefulWidget {
  final Association association;

  const EditAssociationScreen({super.key, required this.association});

  @override
  State<EditAssociationScreen> createState() => _EditAssociationScreenState();
}

class _EditAssociationScreenState extends State<EditAssociationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressRueController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  PlatformFile? _selectedFile;
  late ApiService _apiService;
  bool _isVerified = false;
  List<String> _members = []; // List of member IDs
  List<User> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _populateFields();
    _fetchAllUsers();
  }

  void _populateFields() {
    _nameController.text = widget.association.name;
    _addressRueController.text = widget.association.addressRue;
    _cpController.text = widget.association.cp;
    _villeController.text = widget.association.ville;
    _phoneController.text = widget.association.phone;
    _emailController.text = widget.association.email;
    _isVerified = widget.association.verified ?? false;
    _members = List<String>.from(widget.association.members); // Extracting IDs
  }

  Future<void> _fetchAllUsers() async {
    try {
      final users = await _apiService.fetchAllUsers();
      setState(() {
        _allUsers = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      Association updatedAssociation = widget.association.copyWith(
        name: _nameController.text,
        addressRue: _addressRueController.text,
        cp: _cpController.text,
        ville: _villeController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        members: _members, // Using IDs
      );

      try {
        await _apiService.updateAssociation(updatedAssociation, _selectedFile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Association updated successfully')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update association: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
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

  void _toggleMember(String memberId) {
    setState(() {
      if (_members.contains(memberId)) {
        _members.remove(memberId);
      } else {
        _members.add(memberId);
      }
    });
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {bool readOnly = false, void Function()? onTap, Icon? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[100]!),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer $label de l\'association';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildMembersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Members', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Ajouter des membres',
            border: InputBorder.none,
          ),
          items: _allUsers.map((User user) {
            return DropdownMenuItem<String>(
              value: user.id,
              child: Text(user.name),
            );
          }).toList(),
          onChanged: (String? newUserId) {
            if (newUserId != null) {
              _toggleMember(newUserId);
            }
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: _members.map((memberId) {
            User? member = _allUsers.firstWhere((user) => user.id == memberId, orElse: () => User(id: memberId, name: 'Unknown', email: '',addressRue: '', cp:'', ville : ''  ));
            return Chip(
              label: Text(member.name),
              onDeleted: () {
                _toggleMember(memberId);
              },
              backgroundColor: _members.contains(memberId) ? Colors.orange[100] : null,
            );
          }).toList(),
        ),
      ],
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.white,
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
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
                        _buildTextFormField(_nameController, 'Nom'),
                        const SizedBox(height: 10),
                        _buildTextFormField(_addressRueController, 'Adresse'),
                        const SizedBox(height: 10),
                        _buildTextFormField(_cpController, 'Code Postal'),
                        const SizedBox(height: 10),
                        _buildTextFormField(_villeController, 'Ville'),
                        const SizedBox(height: 10),
                        _buildTextFormField(_phoneController, 'Téléphone'),
                        const SizedBox(height: 10),
                        _buildTextFormField(_emailController, 'Email'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _pickFile,
                          child: Text(_selectedFile == null ? 'Select PDF' : 'PDF Selected: ${_selectedFile!.name}'),
                        ),
                        const SizedBox(height: 15),
                        _buildMembersList(),
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
            ],
          ),
        ),
      ),
    );
  }
}
