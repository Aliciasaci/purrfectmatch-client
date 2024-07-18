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

class EditCatDetails extends StatefulWidget {
  final Cat cat;

  const EditCatDetails({super.key, required this.cat});

  @override
  _EditCatDetailsState createState() => _EditCatDetailsState();
}

class _EditCatDetailsState extends State<EditCatDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _lastVaccineDateController = TextEditingController();
  final TextEditingController _lastVaccineNameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _behaviorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedValue;
  late bool _sterilized;
  late bool _reserved;
  int? _dropdownValue;
  PlatformFile? _selectedFile;
  Map<int?, String> raceList = {};
  final List<String> _options = ['male', 'female'];
  int? _selectedAssociation;
  User? currentUser;
  Map<int, String> _userAssociations = {};

  @override
  void initState() {
    super.initState();
    _populateFields();
    _fetchCatRaces();
    _loadCurrentUser();
  }

  void _populateFields() {
    _nameController.text = widget.cat.name;
    _birthDateController.text = _formatDate(widget.cat.birthDate);
    _lastVaccineDateController.text = _formatDate(widget.cat.lastVaccineDate);
    _lastVaccineNameController.text = widget.cat.lastVaccineName;
    _colorController.text = widget.cat.color;
    _behaviorController.text = widget.cat.behavior;
    _descriptionController.text = widget.cat.description;
    _selectedValue = widget.cat.sexe.toLowerCase();  // Ensure the value matches the options in _options
    _sterilized = widget.cat.sterilized;
    _reserved = widget.cat.reserved;
    _dropdownValue = int.tryParse(widget.cat.raceID);
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return date;
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
    FilePickerResult? result = await FilePicker.platform.pickFiles();

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
        SnackBar(content: Text(AppLocalizations.of(context)!.noFileSelected)),
      );
    }
  }

  Future<void> _saveChanges() async {
    String formattedBirthDate = _birthDateController.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').format(DateFormat('dd-MM-yyyy').parse(_birthDateController.text))
        : '';
    String formattedLastVaccineDate = _lastVaccineDateController.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').format(DateFormat('dd-MM-yyyy').parse(_lastVaccineDateController.text))
        : '';

    Cat updatedCat = Cat(
      ID: widget.cat.ID,
      name: _nameController.text,
      birthDate: formattedBirthDate,
      lastVaccineDate: formattedLastVaccineDate,
      lastVaccineName: _lastVaccineNameController.text,
      color: _colorController.text,
      behavior: _behaviorController.text,
      sterilized: _sterilized,
      raceID: _dropdownValue.toString(),
      description: _descriptionController.text,
      sexe: _selectedValue ?? '',
      reserved: _reserved,
      picturesUrl: widget.cat.picturesUrl,
      userId: widget.cat.userId,
      PublishedAs: _selectedAssociation != null ? _userAssociations[_selectedAssociation] : '', // New field for association
    );

    try {
      await ApiService().updateCat(updatedCat, _selectedFile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.modificationSuccess)),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.registrationFailed)),
      );
    }
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
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.selectAssociation,
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
        title: Text(AppLocalizations.of(context)!.editCatDetailsTitle),
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
                      if (widget.cat.picturesUrl.isNotEmpty)
                        Center(
                          child: Image.network(
                            widget.cat.picturesUrl[0],
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                      _buildTextFormField(_nameController, AppLocalizations.of(context)!.name),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        _birthDateController,
                        AppLocalizations.of(context)!.birthDate,
                        readOnly: true,
                        onTap: () => _selectDate(context, _birthDateController),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        _lastVaccineDateController,
                        AppLocalizations.of(context)!.lastVaccineDate,
                        readOnly: true,
                        onTap: () => _selectDate(context, _lastVaccineDateController),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      const SizedBox(height: 10),
                      _buildTextFormField(_lastVaccineNameController, AppLocalizations.of(context)!.lastVaccineName),
                      const SizedBox(height: 10),
                      _buildTextFormField(_colorController, AppLocalizations.of(context)!.color),
                      const SizedBox(height: 10),
                      _buildTextFormField(_behaviorController, AppLocalizations.of(context)!.behavior),
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
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.race,
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
                        AppLocalizations.of(context)!.description,
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
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.selectGender,
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
                        title: Text(AppLocalizations.of(context)!.sterilized),
                        value: _sterilized,
                        onChanged: (bool value) {
                          setState(() {
                            _sterilized = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.reserved),
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
                          _selectedFile == null
                              ? AppLocalizations.of(context)!.selectPhoto
                              : '${AppLocalizations.of(context)!.photoSelected}: ${_selectedFile!.name}',
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
                            child: Text(AppLocalizations.of(context)!.saveChanges),
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
