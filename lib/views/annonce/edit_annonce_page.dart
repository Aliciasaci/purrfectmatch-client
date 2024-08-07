import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/annonce.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditAnnoncePage extends StatefulWidget {
  final Annonce annonce;

  const EditAnnoncePage({super.key, required this.annonce});

  @override
  _EditAnnoncePageState createState() => _EditAnnoncePageState();
}

class _EditAnnoncePageState extends State<EditAnnoncePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  List<Cat> _userCats = [];
  Cat? _selectedCat;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.annonce.Title;
    _descriptionController.text = widget.annonce.Description ?? '';
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
            _selectedCat = cats.firstWhere(
                  (cat) => cat.ID.toString() == widget.annonce.CatID,
            );
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

  Future<void> _updateAnnonce() async {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || _selectedCat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final updatedAnnonce = widget.annonce.copyWith(
      Title: title,
      Description: description,
      CatID: _selectedCat!.ID.toString(),
    );

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService().updateAnnonce(updatedAnnonce);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Annonce mise à jour avec succès')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour de l\'annonce: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[100]!),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          icon: icon != null ? Icon(icon, color: Colors.orange[100]) : null,
          border: InputBorder.none,
          labelText: labelText,
        ),
      ),
    );
  }

  Widget buildDropdownFormField({
    required List<DropdownMenuItem<Cat>> items,
    required String labelText,
    required Cat? value,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[100]!),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButtonFormField<Cat>(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
        ),
        items: items,
        onChanged: (Cat? newValue) {
          setState(() {
            _selectedCat = newValue;
          });
        },
        value: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'annonce'),
        backgroundColor: Colors.orange[100],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange[100]!, Colors.orange[200]!],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      child: Column(
                        children: [
                          buildTextFormField(
                            controller: _titleController,
                            labelText: "Titre de l'annonce",
                            icon: Icons.title,
                          ),
                          const SizedBox(height: 15),
                          buildTextFormField(
                            controller: _descriptionController,
                            labelText: "Description",
                            icon: Icons.description,
                          ),
                          const SizedBox(height: 15),
                          buildDropdownFormField(
                            items: _userCats.map((Cat cat) {
                              return DropdownMenuItem<Cat>(
                                value: cat,
                                child: Text(cat.name),
                              );
                            }).toList(),
                            labelText: "Sélectionner un chat",
                            value: _selectedCat,
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _updateAnnonce,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[100],
                                padding: const EdgeInsets.all(15),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                AppLocalizations.of(context)!.save,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
