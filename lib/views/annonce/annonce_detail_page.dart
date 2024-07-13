import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/annonce.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../cat/cat_details.dart';

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

  @override
  void initState() {
    super.initState();
    _populateFields();
    _fetchCatDetails();
  }

  void _populateFields() {
    _titleController.text = widget.annonce.Title;
    _descriptionController.text = widget.annonce.Description;
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
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    _toggleEditing();
  }

  @override
  Widget build(BuildContext context) {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    final currentUser = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.annonceDetailsTitle),
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
                    _loadingCat
                        ? const Center(child: CircularProgressIndicator())
                        : _cat != null && _cat!.picturesUrl.isNotEmpty
                        ? Image.network(
                      _cat!.picturesUrl.first,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      height: 300,
                      color: Colors.grey,
                      child: const Icon(Icons.image, size: 100),
                    ),
                    const SizedBox(height: 20),
                    if (_cat != null)
                      Text(
                        _cat!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      widget.annonce.Title,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.annonce.Description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    if (currentUser != null &&
                        widget.annonce.UserID == currentUser.id)
                      ElevatedButton(
                        onPressed: _isEditing ? _saveChanges : _toggleEditing,
                        child: Text(_isEditing
                            ? AppLocalizations.of(context)!.save
                            : AppLocalizations.of(context)!.edit),
                      ),
                    if (_cat != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.catDetailsTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${AppLocalizations.of(context)!.gender}: ${_cat!.sexe}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${AppLocalizations.of(context)!.color}: ${_cat!.color}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${AppLocalizations.of(context)!.behavior}: ${_cat!.behavior}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CatDetails(cat: _cat!)),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.seeMore),
                            ),
                          ),
                        ],
                      ),
                    if (_cat == null)
                      Text(AppLocalizations.of(context)!.noCatInfoAvailable),
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
