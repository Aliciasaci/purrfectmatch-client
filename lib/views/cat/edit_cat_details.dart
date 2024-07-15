import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import 'package:file_picker/file_picker.dart';

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
  final TextEditingController _sexeController = TextEditingController();
  late bool _sterilized;
  late bool _reserved;
  int? _dropdownValue;
  PlatformFile? _selectedFile;
  Map<int?, String> raceList = {};

  @override
  void initState() {
    super.initState();
    _populateFields();
    _fetchCatRaces();
  }

  void _populateFields() {
    _nameController.text = widget.cat.name;
    _birthDateController.text = _formatDate(widget.cat.birthDate);
    _lastVaccineDateController.text = _formatDate(widget.cat.lastVaccineDate);
    _lastVaccineNameController.text = widget.cat.lastVaccineName;
    _colorController.text = widget.cat.color;
    _behaviorController.text = widget.cat.behavior;
    _descriptionController.text = widget.cat.description;
    _sexeController.text = widget.cat.sexe;
    _sterilized = widget.cat.sterilized;
    _reserved = widget.cat.reserved;
    _dropdownValue = int.tryParse(widget.cat.raceID);
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd').parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
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
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

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
    String formattedBirthDate = _birthDateController.text.isNotEmpty
        ? DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd').parse(_birthDateController.text))
        : '';
    String formattedLastVaccineDate = _lastVaccineDateController.text.isNotEmpty
        ? DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd').parse(_lastVaccineDateController.text))
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
      sexe: _sexeController.text,
      reserved: _reserved,
      picturesUrl: widget.cat.picturesUrl,
      userId: widget.cat.userId,
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
                      _buildTextFormField(_nameController, 'Name'),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        _birthDateController,
                        'Birth Date',
                        readOnly: true,
                        onTap: () => _selectDate(context, _birthDateController),
                        suffixIcon: const Icon(Icons.calendar_today),
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
                      _buildTextFormField(_colorController, 'Color'),
                      const SizedBox(height: 10),
                      _buildTextFormField(_behaviorController, 'Behavior'),
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
                            labelText: 'Race',
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
                      _buildTextFormField(_sexeController, 'Gender'),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: const Text('Sterilized'),
                        value: _sterilized,
                        onChanged: (bool value) {
                          setState(() {
                            _sterilized = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Reserved'),
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
                          _selectedFile == null ? 'Select Photo' : 'Photo Selected: ${_selectedFile!.name}',
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
