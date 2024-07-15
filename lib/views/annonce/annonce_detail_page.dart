import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/annonce.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../cat/cat_details.dart';
import 'edit_annonce_page.dart';

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
  String _annonceAddress = "";
  final ApiService apiService = ApiService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _annonceAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFields();
    _fetchCatDetails();
  }

  void _populateFields() {
    _titleController.text = widget.annonce.Title;
    _descriptionController.text = widget.annonce.Description ?? '';
  }

  Future<void> _fetchCatDetails() async {
    if (widget.annonce.CatID != null) {
      try {
        final apiService = ApiService();
        final cat = await apiService.fetchCatByID(widget.annonce.CatID!);
        final annonceAddress = await apiService.getUserAddressFromAnnonceID(widget.annonce.UserID);
        setState(() {
          _cat = cat;
          _loadingCat = false;
          _annonceAddress = annonceAddress;
        });
        _annonceAddressController.text = _annonceAddress;
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

  void _navigateToEditAnnonce() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAnnoncePage(annonce: widget.annonce),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh annonce details
        _fetchCatDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    final currentUser = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.annonceDetailsTitle),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
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
                          if (_isEditing)
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.title,
                                border: const OutlineInputBorder(),
                              ),
                            )
                          else
                            Text(
                              widget.annonce.Title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          const SizedBox(height: 15),
                          if (_isEditing)
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText:
                                AppLocalizations.of(context)!.description,
                                border: const OutlineInputBorder(),
                              ),
                              maxLines: null,
                            )
                          else
                            Text(
                              widget.annonce.Description ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _annonceAddressController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: "Adresse du chat",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_cat != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.catDetailsTitle,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${AppLocalizations.of(context)!.name}: ${_cat!.name}',
                                  style: const TextStyle(fontSize: 16),
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
                              ],
                            ),
                          if (_cat == null)
                            Text(
                                AppLocalizations.of(context)!.noCatInfoAvailable),
                          if (currentUser != null &&
                              widget.annonce.UserID == currentUser.id)
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.orange[100],
                                        padding: const EdgeInsets.all(15),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CatDetails(cat: _cat!)),
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .catDetails,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.orange[100],
                                        padding: const EdgeInsets.all(15),
                                      ),
                                      onPressed: _navigateToEditAnnonce,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .editAnnonce,
                                        style: const TextStyle(
                                            color: Colors.black),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
