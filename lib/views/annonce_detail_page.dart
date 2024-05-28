import 'package:flutter/material.dart';
import '../models/annonce.dart';

class AnnonceDetailPage extends StatefulWidget {
  final Annonce annonce;

  const AnnonceDetailPage({super.key, required this.annonce});

  @override
  _AnnonceDetailPageState createState() => _AnnonceDetailPageState();
}

class _AnnonceDetailPageState extends State<AnnonceDetailPage> {
  bool _isEditing = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _catIDController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFields();
    print('====>Annonce créée : ${widget.annonce}');
  }

  void _populateFields() {
    _titleController.text = widget.annonce.Title;
    _descriptionController.text = widget.annonce.Description;
    _catIDController.text = widget.annonce.CatID ?? '';
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    // Implement the save functionality here, for example, calling an API to save the changes
    // For now, just print the values to console
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Cat ID: ${_catIDController.text}');
    _toggleEditing(); // Switch back to non-editing mode
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'annonce'),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.white,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Détails de l\'annonce',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                        labelText: "Titre de l'annonce",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 2,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _catIDController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                        labelText: "ID du chat",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Retour'),
                        ),
                        const SizedBox(width: 7),
                        ElevatedButton(
                          onPressed: _isEditing ? _saveChanges : _toggleEditing,
                          child: Text(_isEditing ? 'Valider' : 'Modifier'),
                        ),
                      ],
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
