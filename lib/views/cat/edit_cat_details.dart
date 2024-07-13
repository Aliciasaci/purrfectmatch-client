import 'package:flutter/material.dart';
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
    _sterilizedController.text = widget.cat.sterilized ? 'Oui' : 'Non';
    _reservedController.text = widget.cat.reserved ? 'Oui' : 'Non';
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
        title: const Text('Modifier les détails du chat'),
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
                        labelText: 'Nom',
                        border: OutlineInputBorder(),
                      ),
                      controller: _nameController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Date de Naissance',
                        border: OutlineInputBorder(),
                      ),
                      controller: _birthDateController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Date du dernier vaccin',
                        border: OutlineInputBorder(),
                      ),
                      controller: _lastVaccineDateController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nom du dernier vaccin',
                        border: OutlineInputBorder(),
                      ),
                      controller: _lastVaccineNameController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Couleur',
                        border: OutlineInputBorder(),
                      ),
                      controller: _colorController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Comportement',
                        border: OutlineInputBorder(),
                      ),
                      controller: _behaviorController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Race',
                        border: OutlineInputBorder(),
                      ),
                      controller: _raceController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      controller: _descriptionController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Genre',
                        border: OutlineInputBorder(),
                      ),
                      controller: _sexeController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Stérilisé',
                        border: OutlineInputBorder(),
                      ),
                      controller: _sterilizedController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Réservé',
                        border: OutlineInputBorder(),
                      ),
                      controller: _reservedController,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        child: const Text('Valider'),
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
