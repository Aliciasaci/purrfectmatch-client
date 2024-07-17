import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../models/user.dart';
import '../../models/association.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCat extends StatefulWidget {
  const AddCat({super.key});

  @override
  State<AddCat> createState() => _AddCatState();
}

class _AddCatState extends State<AddCat> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sexeController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _lastVaccineDateController = TextEditingController();
  final TextEditingController _lastVaccineNameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _behaviorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedValue;
  int? _selectedAssociation;
  bool _sterilized = false;
  bool _reserved = false;
  final List<String> _options = ['male', 'female'];
  PlatformFile? _selectedFile;
  Map<int?, String> raceList = {};
  int? _dropdownValue;
  User? currentUser;
  Map<int, String> _userAssociations = {};

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _lastVaccineDateController.dispose();
    _lastVaccineNameController.dispose();
    _colorController.dispose();
    _behaviorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCatRaces();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      setState(() {
        currentUser = authState.user;
      });
      await _fetchUserAssociations();
    }
  }

  Future<void> _fetchUserAssociations() async {
    if (currentUser != null) {
      try {
        final apiService = ApiService();
        final associations = await apiService.fetchUserAssociations(currentUser!.id!);
        setState(() {
          _userAssociations = {for (var assoc in associations) assoc.ID!: assoc.Name};
          _selectedAssociation = null; // Ensure default value is null
        });
      } catch (e) {
        print('Failed to load associations: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpeg', 'jpg']);

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });

      // Afficher les informations sur le fichier sélectionné
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

  Future<void> _fetchCatRaces() async {
    try {
      final apiService = ApiService();
      final newRaces = await apiService.fetchAllRaces();
      setState(() {
        raceList = {for (var race in newRaces) race.id: race.raceName};
      });
    } catch (e) {
      print('Failed to load races: $e');
    }
  }

  Future<void> _sendData() async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    if (_nameController.text.isEmpty || _birthDateController.text.isEmpty || _colorController.text.isEmpty || _behaviorController.text.isEmpty || _dropdownValue == null || _selectedValue == null || _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Format the dates
    String formattedBirthDate = _birthDateController.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(_birthDateController.text))
        : '';
    String formattedLastVaccineDate = _lastVaccineDateController.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(_lastVaccineDateController.text))
        : '';

    Cat cat = Cat(
      name: _nameController.text,
      birthDate: formattedBirthDate,
      lastVaccineDate: formattedLastVaccineDate,
      lastVaccineName: _lastVaccineNameController.text.isNotEmpty ? _lastVaccineNameController.text : '',
      color: _colorController.text,
      behavior: _behaviorController.text,
      raceID: _dropdownValue.toString(),
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : '',
      sexe: _selectedValue ?? '',
      sterilized: _sterilized,
      reserved: _reserved,
      picturesUrl: _selectedFile != null ? [_selectedFile!.name] : [],
      userId: currentUser!.id,
      PublishedAs: _selectedAssociation != null ? _userAssociations[_selectedAssociation] : '', // New field for association
    );

    try {
      await ApiService().createCat(cat, _selectedFile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat crée avec succès !')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending data: $e')),
      );
    }
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {bool readOnly = false, void Function()? onTap, Icon? suffixIcon, bool isRequired = false}) {
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
          labelText: isRequired ? '$label*' : label,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildAssociationDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange[100]!,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButtonFormField<int>(
        decoration: const InputDecoration(
          labelText: 'Select Association (optional)',
          border: InputBorder.none,
        ),
        items: _userAssociations.entries.map((entry) {
          return DropdownMenuItem<int>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        value: _selectedAssociation,
        onChanged: (int? newValue) {
          setState(() {
            _selectedAssociation = newValue;
          });
        },
        isExpanded: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addCatTitle),
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
                      _buildTextFormField(_nameController, 'Name', isRequired: true),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        _birthDateController,
                        'Birth Date',
                        readOnly: true,
                        onTap: () => _selectDate(context, _birthDateController),
                        suffixIcon: const Icon(Icons.calendar_today),
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        _lastVaccineDateController,
                        'Last Vaccine Date',
                        readOnly: true,
                        onTap: () => _selectDate(context, _lastVaccineDateController),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      const SizedBox(height: 10),
                      _buildTextFormField(_lastVaccineNameController, 'Last Vaccine Name'),
                      const SizedBox(height: 10),
                      _buildTextFormField(_colorController, 'Color', isRequired: true),
                      const SizedBox(height: 10),
                      _buildTextFormField(_behaviorController, 'Behavior', isRequired: true),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orange[100]!,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Race*',
                            border: InputBorder.none,
                          ),
                          items: raceList.entries.map((entry) {
                            return DropdownMenuItem<int>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          value: _dropdownValue,
                          onChanged: (int? newValue) {
                            setState(() {
                              _dropdownValue = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        _descriptionController,
                        'Description',
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orange[100]!,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Gender*',
                            border: InputBorder.none,
                          ),
                          value: _selectedValue,
                          items: _options.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedValue = newValue;
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildAssociationDropdown(),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: const Text('Sterilized*'),
                        value: _sterilized,
                        onChanged: (bool value) {
                          setState(() {
                            _sterilized = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Reserved*'),
                        value: _reserved,
                        onChanged: (bool value) {
                          setState(() {
                            _reserved = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: Text(
                          _selectedFile == null ? 'Select Photo*' : 'Photo Selected*: ${_selectedFile!.name}',
                        ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _sendData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[100],
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text('Add Cat'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
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
