import 'package:flutter/material.dart';
import '../models/annonce.dart';
import '../models/cat.dart';
import '../services/api_service.dart';

class AnnonceDetailPage extends StatefulWidget {
  final Annonce annonce;

  const AnnonceDetailPage({super.key, required this.annonce});

  @override
  _AnnonceDetailPageState createState() => _AnnonceDetailPageState();
}

class _AnnonceDetailPageState extends State<AnnonceDetailPage> {
  bool _isEditing = false;
  Cat? _cat;
  bool _loadingCat = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _catIDController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFields();
    _fetchCatDetails();
    print('====>Annonce créée : ${widget.annonce}');
  }

  void _populateFields() {
    _titleController.text = widget.annonce.Title;
    _descriptionController.text = widget.annonce.Description;
    _catIDController.text = widget.annonce.CatID ?? '';
  }

  Future<void> _fetchCatDetails() async {
    if (widget.annonce.CatID != null) {
      try {
        final apiService = ApiService();
        final cat = await apiService.fetchCatByID(widget.annonce.CatID!);
        setState(() {
          _cat = cat;
          _loadingCat = false;
        });
      } catch (e) {
        print('Failed to load cat details: $e');
        setState(() {
          _loadingCat = false;
        });
      }
    } else {
      setState(() {
        _loadingCat = false;
      });
    }
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
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _loadingCat
                  ? const Center(child: CircularProgressIndicator())
                  : _cat != null && _cat!.picturesUrl.isNotEmpty
                  ? Image.network(
                _cat!.picturesUrl.first,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
                  : Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey,
                child: const Icon(Icons.image, size: 100),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                    const SizedBox(height: 20),
                    _cat != null
                        ? Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informations sur le chat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text('Nom: ${_cat!.name}'),
                            Text('Date de naissance: ${_cat!.birthDate}'),
                            Text('Sexe: ${_cat!.sexe}'),
                            Text('Couleur: ${_cat!.color}'),
                            Text('Comportement: ${_cat!.behavior}'),
                            Text('Stérilisé: ${_cat!.sterilized ? 'Oui' : 'Non'}'),
                            Text('Race: ${_cat!.race}'),
                            Text('Description: ${_cat!.description}'),
                          ],
                        ),
                      ),
                    )
                        : const Text('Aucune information sur le chat disponible'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
