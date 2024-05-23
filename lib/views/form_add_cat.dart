import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:purrfectmatch/services/api_service.dart';
import '../models/cat.dart';

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
  final TextEditingController _raceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedValue;
  bool _sterilized = false;
  bool _reserved = false;
  final List<String> _options = ['male', 'femelle'];

  @override
  void dispose() {
    _nameController.dispose();
    _sexeController.dispose();
    _birthDateController.dispose();
    _lastVaccineDateController.dispose();
    _lastVaccineNameController.dispose();
    _colorController.dispose();
    _behaviorController.dispose();
    _raceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _sendData() async {
    Cat cat = Cat(
      name: _nameController.text,
      sexe : _sexeController.text,
      birthDate: _birthDateController.text,
      lastVaccineDate: _lastVaccineDateController.text,
      lastVaccineName: _lastVaccineNameController.text,
      color: _colorController.text,
      behavior: _behaviorController.text,
      race: _raceController.text,
      description: _descriptionController.text,
      gender: _selectedValue ?? '',
      sterilized: _sterilized,
      reserved: _reserved,
    );

    try {
      await ApiService().createCat(cat);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Données envoyées avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi des données: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
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
                  const Text(
                    'Créer un profil de chat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildTextFormField(_nameController, "Nom*"),
                  SizedBox(height: 10),
                  buildTextFormFieldWithDatepicker(_sexeController, "Sexe*", context),
                  SizedBox(height: 10),
                  buildTextFormFieldWithDatepicker(_birthDateController, "Date de Naissance*", context),
                  SizedBox(height: 10),
                  buildTextFormFieldWithDatepicker(_lastVaccineDateController, "Date du dernier vaccin", context),
                  SizedBox(height: 10),
                  buildTextFormField(_lastVaccineNameController, "Nom du dernier vaccin"),
                  SizedBox(height: 10),
                  buildTextFormField(_colorController, "Couleur*"),
                  SizedBox(height: 10),
                  buildTextFormField(_behaviorController, "Comportement*"),
                  SizedBox(height: 10),
                  buildTextFormField(_raceController, "Race*"),
                  SizedBox(height: 10),
                  buildDescriptionFormField(_descriptionController),
                  SizedBox(height: 10),
                  buildGenderDropdown(),
                  SizedBox(height: 10),
                  buildSwitchTile("Stérilisé*", _sterilized, (value) => setState(() => _sterilized = value)),
                  buildSwitchTile("Réservé*", _reserved, (value) => setState(() => _reserved = value)),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _sendData,
                    child: const Text('Envoyer'),
                  ),
                  const SizedBox(height: 15),
                ],
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
      border: OutlineInputBorder(),
    ),
  );

  Widget buildTextFormFieldWithDatepicker(TextEditingController controller, String label, BuildContext context) => TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.calendar_today),
    ),
    readOnly: true,
    onTap: () => _selectDate(context, controller),
  );

  Widget buildDescriptionFormField(TextEditingController controller) => TextFormField(
    controller: controller,
    maxLines: 3,
    decoration: InputDecoration(
      labelText: "Description",
      border: OutlineInputBorder(),
    ),
  );

  Widget buildGenderDropdown() => DropdownButton<String>(
    value: _selectedValue,
    hint: const Text('Sélectionnez un genre'),
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
}
