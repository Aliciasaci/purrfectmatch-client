import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/cat.dart';

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
  final TextEditingController _raceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sexeController = TextEditingController();
  final TextEditingController _sterilizedController = TextEditingController();
  final TextEditingController _reservedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() {
    _nameController.text = widget.cat.name;
    _birthDateController.text = widget.cat.birthDate;
    _lastVaccineDateController.text = widget.cat.lastVaccineDate;
    _lastVaccineNameController.text = widget.cat.lastVaccineName;
    _colorController.text = widget.cat.color;
    _behaviorController.text = widget.cat.behavior;
    _raceController.text = widget.cat.race;
    _descriptionController.text = widget.cat.description;
    _sexeController.text = widget.cat.sexe;
    _sterilizedController.text = widget.cat.sterilized ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no;
    _reservedController.text = widget.cat.reserved ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no;
  }

  void _saveChanges() {
    // For now, just print the values to console
    print('Name: ${_nameController.text}');
    print('Birth Date: ${_birthDateController.text}');
    print('Last Vaccine Date: ${_lastVaccineDateController.text}');
    print('Last Vaccine Name: ${_lastVaccineNameController.text}');
    print('Color: ${_colorController.text}');
    print('Behavior: ${_behaviorController.text}');
    print('Race: ${_raceController.text}');
    print('Description: ${_descriptionController.text}');
    print('Sexe: ${_sexeController.text}');
    print('Sterilized: ${_sterilizedController.text}');
    print('Reserved: ${_reservedController.text}');
    Navigator.pop(context); // Navigate back to the details page after saving changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editCatDetailsTitle),
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
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.name,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _nameController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.birthDate,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _birthDateController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.lastVaccineDate,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _lastVaccineDateController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.lastVaccineName,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _lastVaccineNameController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.color,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _colorController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.behavior,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _behaviorController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.race,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _raceController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.description,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _descriptionController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.gender,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _sexeController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.sterilized,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _sterilizedController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.reserved,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _reservedController,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        child: Text(AppLocalizations.of(context)!.edit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
