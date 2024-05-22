import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class AddCat extends StatefulWidget {
  const AddCat({super.key});

  @override
  State<AddCat> createState() => _AddCatState();
}

class _AddCatState extends State<AddCat> {
  final TextEditingController _nameController = TextEditingController();
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
                  buildTextFormField(_nameController, "Nom"),
                  buildTextFormFieldWithDatepicker(_birthDateController, "Date de Naissance", context),
                  buildTextFormFieldWithDatepicker(_lastVaccineDateController, "Date du dernier vaccin", context),
                  buildTextFormField(_lastVaccineNameController, "Nom du dernier vaccin"),
                  buildTextFormField(_colorController, "Couleur"),
                  buildTextFormField(_behaviorController, "Comportement"),
                  buildTextFormField(_raceController, "Race"),
                  buildDescriptionFormField(_descriptionController),
                  buildGenderDropdown(),
                  buildSwitchTile("Stérilisé", _sterilized, (value) => setState(() => _sterilized = value)),
                  buildSwitchTile("Réservé", _reserved, (value) => setState(() => _reserved = value)),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => print('Formulaire envoyé'),
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
