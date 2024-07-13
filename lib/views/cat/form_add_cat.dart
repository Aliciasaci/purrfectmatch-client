import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../models/user.dart';

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
  bool _sterilized = false;
  bool _reserved = false;
  final List<String> _options = ['male', 'femelle'];
  PlatformFile? _selectedFile;
  Map<int?, String> raceList = {};
  int? _dropdownValue;
  late User currentUser;

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
    var status = await Permission.storage.request();

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.storagePermissionDenied)),
      );
    }
  }

  Future<void> _fetchCatRaces() async {
    try {
      final apiService = ApiService();
      final newRaces = await apiService.fetchAllRaces();
      for (var race in newRaces) {
        raceList[race.id] = race.raceName;
      }
      setState(() {
        raceList = raceList;
      });
    } catch (e) {
      print('Failed to load races: $e');
    }
  }

  Future<void> _sendData() async {
    Cat cat = Cat(
      name: _nameController.text,
      birthDate: _birthDateController.text,
      lastVaccineDate: _lastVaccineDateController.text,
      lastVaccineName: _lastVaccineNameController.text,
      color: _colorController.text,
      behavior: _behaviorController.text,
      race: _dropdownValue?.toString() ?? '',
      description: _descriptionController.text,
      sexe: _selectedValue ?? '',
      sterilized: _sterilized,
      reserved: _reserved,
      picturesUrl: _selectedFile != null ? [_selectedFile!.name] : [],
      userId: currentUser.id ?? '',
    );

    try {
      await ApiService().createCat(cat, _selectedFile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.dataSentSuccessfully)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.dataSendError}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(AppLocalizations.of(context)!.addCat),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amberAccent[100]!, Colors.orange[400]!],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.createCatProfile,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildTextFormField(_nameController, AppLocalizations.of(context)!.name),
                      const SizedBox(height: 10),
                      buildTextFormFieldWithDatepicker(_birthDateController, AppLocalizations.of(context)!.birthDate, context),
                      const SizedBox(height: 10),
                      buildTextFormFieldWithDatepicker(_lastVaccineDateController, AppLocalizations.of(context)!.lastVaccineDate, context),
                      const SizedBox(height: 10),
                      buildTextFormField(_lastVaccineNameController, AppLocalizations.of(context)!.lastVaccineName),
                      const SizedBox(height: 10),
                      buildTextFormField(_colorController, AppLocalizations.of(context)!.color),
                      const SizedBox(height: 10),
                      buildTextFormField(_behaviorController, AppLocalizations.of(context)!.behavior),
                      const SizedBox(height: 10),
                      buildRaceSelectFormField(raceList, AppLocalizations.of(context)!.race),
                      const SizedBox(height: 10),
                      buildDescriptionFormField(_descriptionController, AppLocalizations.of(context)!.description),
                      const SizedBox(height: 10),
                      buildSexeDropdown(AppLocalizations.of(context)!.selectGender),
                      const SizedBox(height: 10),
                      buildSwitchTile(AppLocalizations.of(context)!.sterilized, _sterilized, (value) => setState(() => _sterilized = value)),
                      buildSwitchTile(AppLocalizations.of(context)!.reserved, _reserved, (value) => setState(() => _reserved = value)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: Text(_selectedFile == null ? AppLocalizations.of(context)!.selectPhoto : '${AppLocalizations.of(context)!.photoSelected}: ${_selectedFile!.name}'),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _sendData,
                        child: Text(AppLocalizations.of(context)!.send),
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

  Widget buildTextFormField(TextEditingController controller, String label) => TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );

  Widget buildTextFormFieldWithDatepicker(TextEditingController controller, String label, BuildContext context) => TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      suffixIcon: const Icon(Icons.calendar_today),
    ),
    readOnly: true,
    onTap: () => _selectDate(context, controller),
  );

  Widget buildDescriptionFormField(TextEditingController controller, String label) => TextFormField(
    controller: controller,
    maxLines: 3,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );

  Widget buildSexeDropdown(String hint) => DropdownButton<String>(
    value: _selectedValue,
    hint: Text(hint),
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
  );

  Widget buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) => SwitchListTile(
    title: Text(title),
    value: value,
    onChanged: onChanged,
  );

  Widget buildRaceSelectFormField(Map<int?, String> items, String hint) => DropdownButton(
    hint: Text(hint),
    items: items.entries.map((entry) {
      return DropdownMenuItem<dynamic>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList(),
    value: _dropdownValue,
    onChanged: (dynamic newValue) {
      setState(() {
        _dropdownValue = newValue;
      });
    },
  );
}
