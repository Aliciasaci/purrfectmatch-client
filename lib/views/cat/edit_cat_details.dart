import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';

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
  late bool _sterilized;
  late bool _reserved;

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
    _raceController.text = widget.cat.raceID;
    _descriptionController.text = widget.cat.description;
    _sexeController.text = widget.cat.sexe;
    _sterilized = widget.cat.sterilized;
    _reserved = widget.cat.reserved;
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
    }
  }

  void _saveChanges() async {
    Cat updatedCat = Cat(
      ID: widget.cat.ID,
      name: _nameController.text,
      birthDate: _birthDateController.text,
      lastVaccineDate: _lastVaccineDateController.text,
      lastVaccineName: _lastVaccineNameController.text,
      color: _colorController.text,
      behavior: _behaviorController.text,
      sterilized: _sterilized,
      raceID: _raceController.text,
      description: _descriptionController.text,
      sexe: _sexeController.text,
      reserved: _reserved,
      picturesUrl: widget.cat.picturesUrl,
      userId: widget.cat.userId,
    );

    try {
      await ApiService().updateCat(updatedCat);
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

  Widget _buildTextField(TextEditingController controller, String label, {bool readOnly = false, void Function()? onTap, Icon? suffixIcon}) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildTextField(_nameController, AppLocalizations.of(context)!.name),
                    const SizedBox(height: 10),
                    _buildTextField(
                      _birthDateController,
                      AppLocalizations.of(context)!.birthDate,
                      readOnly: true,
                      onTap: () => _selectDate(context, _birthDateController),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      _lastVaccineDateController,
                      AppLocalizations.of(context)!.lastVaccineDate,
                      readOnly: true,
                      onTap: () => _selectDate(context, _lastVaccineDateController),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(_lastVaccineNameController, AppLocalizations.of(context)!.lastVaccineName),
                    const SizedBox(height: 10),
                    _buildTextField(_colorController, AppLocalizations.of(context)!.color),
                    const SizedBox(height: 10),
                    _buildTextField(_behaviorController, AppLocalizations.of(context)!.behavior),
                    const SizedBox(height: 10),
                    _buildTextField(_raceController, AppLocalizations.of(context)!.race),
                    const SizedBox(height: 10),
                    _buildTextField(_descriptionController, AppLocalizations.of(context)!.description),
                    const SizedBox(height: 10),
                    _buildTextField(_sexeController, AppLocalizations.of(context)!.gender),
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
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange[100],
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: _saveChanges,
                          child: Text(AppLocalizations.of(context)!.edit),
                        ),
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
