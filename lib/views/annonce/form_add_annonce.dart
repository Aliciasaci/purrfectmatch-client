import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cat/form_add_cat.dart';
import 'annonce_detail_page.dart';
import '../../models/annonce.dart';

class AddAnnonce extends StatefulWidget {
  const AddAnnonce({super.key});

  @override
  _AddAnnonceState createState() => _AddAnnonceState();
}

class _AddAnnonceState extends State<AddAnnonce> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Cat> _userCats = [];
  Cat? _selectedCat;

  @override
  void initState() {
    super.initState();
    _loadUserCats();
  }

  Future<void> _loadUserCats() async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      final userId = authState.user.id;
      if (userId != null) {
        try {
          final cats = await ApiService().fetchCatsByUser(userId);
          setState(() {
            _userCats = cats;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors du chargement des chats: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _sendData() async {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || _selectedCat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    Annonce annonce = Annonce(
      Title: title,
      Description: description.isNotEmpty ? description : '',
      CatID: _selectedCat!.ID.toString(),
    );

    try {
      final createdAnnonce = await ApiService().createAnnonce(annonce);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Annonce créée avec succès')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnnonceDetailPage(annonce: createdAnnonce),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création de l\'annonce: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une nouvelle annonce'),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ajouter une nouvelle annonce',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: "Titre de l'annonce",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<Cat>(
                          decoration: const InputDecoration(
                            labelText: "Sélectionner un chat",
                            border: OutlineInputBorder(),
                          ),
                          items: _userCats.map((Cat cat) {
                            return DropdownMenuItem<Cat>(
                              value: cat,
                              child: Text(cat.name),
                            );
                          }).toList(),
                          onChanged: (Cat? newValue) {
                            setState(() {
                              _selectedCat = newValue;
                            });
                          },
                          value: _selectedCat,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _sendData,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add),
                              SizedBox(width: 8),
                              Text('Ajouter'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Colors.grey,
                          height: 20,
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            minimumSize: const Size(100, 40),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddCat()),
                            );
                          },
                          child: const Text('Ajouter un chat'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
