import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:purrfectmatch/services/api_service.dart';

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
  List<String> _members = [];
  List<User> _validMembers = [];
  List<User> _allUsers = [];
  User? _owner;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _populateFields();
    _fetchAllUsers();
    _fetchOwner();
    _fetchMembers();
  }

  void _populateFields() {
    _nameController.text = widget.association.Name;
    _addressRueController.text = widget.association.AddressRue;
    _cpController.text = widget.association.Cp;
    _villeController.text = widget.association.Ville;
    _phoneController.text = widget.association.Phone;
    _emailController.text = widget.association.Email;
    _members = widget.association.Members != null
        ? List<String>.from(widget.association.Members!).where((id) => id.isNotEmpty).toList()
        : [];
  }

  Future<void> _fetchAllUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final users = await _apiService.fetchAllUsers();
      setState(() {
        _allUsers = users.where((user) => user.id != widget.association.OwnerID).toList(); // Exclude owner from the list
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchOwner() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final owner = await _apiService.fetchUserByID(widget.association.OwnerID);
      setState(() {
        _owner = owner;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load owner: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMembers() async {
    setState(() {
      _isLoading = true;
    });
    List<User> validMembers = [];

    for (String memberId in _members) {
      if (memberId.isNotEmpty) {
        try {
          User member = await _apiService.fetchUserByID(memberId);
          if (member.email.isNotEmpty) {
            validMembers.add(member);
          }
        } catch (e) {
          print('Failed to fetch user with ID $memberId: $e');
        }
      }
    }

    setState(() {
      _validMembers = validMembers;
      _isLoading = false;
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.extension == 'pdf') {
        setState(() {
          _selectedFile = file;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a PDF file')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      List<String> validMembers = _members.where((memberId) => memberId.isNotEmpty).toList();

      Association updatedAssociation = widget.association.copyWith(
        name: _nameController.text,
        addressRue: _addressRueController.text,
        cp: _cpController.text,
        ville: _villeController.text,
        phone: _phoneController.text,
        Email: _emailController.text,
        members: validMembers.isNotEmpty ? validMembers : null,
        kbisFile: _selectedFile?.path,
      );

      try {
        await _apiService.updateAssociation(updatedAssociation, _selectedFile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Association updated successfully')),
        );
        Navigator.pop(context, true); // Return to the previous screen and indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update association: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  void _toggleMember(String memberId) {
    setState(() {
      if (memberId.isNotEmpty) {
        if (_members.contains(memberId)) {
          _members.remove(memberId);
          _validMembers.removeWhere((member) => member.id == memberId);
        } else {
          try {
            final user = _allUsers.firstWhere((user) => user.id == memberId);
            if (user.email.isNotEmpty) {
              _members.add(memberId);
              _validMembers.add(user); // Add the user to valid members if they are valid
            }
          } catch (e) {
            print('User with ID $memberId not found');
          }
        }
      }
    });
    print('Selected member ID: $memberId');
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
    return (widget.association.Verified ?? false)
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Membres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange[100]!),
            borderRadius: BorderRadius.circular(40),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Ajouter des membres',
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.orange[200]),
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
        ),
      ],
    )
        : Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[100]!),
        borderRadius: BorderRadius.circular(40),
        color: Colors.orange[50],
      ),
      child: const Text(
        'Les membres peuvent être ajoutés uniquement si l\'association est vérifiée.',
        style: TextStyle(fontSize: 16, color: Colors.red),
      ),
    );
  }

  Widget _buildOwnerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _owner != null
            ? Container(
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [
              const Icon(Icons.verified_user, color: Colors.orange),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_owner!.name} (Propriétaire)', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(_owner!.email),
                ],
              ),
            ],
          ),
        )
            : const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 10),
        if (_members.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Membres actuels', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: _validMembers.map((member) {
                  return Chip(
                    label: Text(member.name),
                    onDeleted: () {
                      _toggleMember(member.id ?? "");
                    },
                    backgroundColor: Colors.orange[100],
                  );
                }).toList(),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Association'),
        backgroundColor: Colors.orange[100],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
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
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _buildOwnerInfo(),
                          const SizedBox(height: 10),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      child: const Text('Enregistrer les modifications'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
