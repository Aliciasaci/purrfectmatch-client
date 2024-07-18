import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../../models/user.dart';
import '../../models/rating.dart';
import '../../services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';

class UserPublicProfile extends StatefulWidget {
  final User user;

  const UserPublicProfile({super.key, required this.user});

  @override
  _UserPublicProfileState createState() => _UserPublicProfileState();
}

class _UserPublicProfileState extends State<UserPublicProfile> {
  final ApiService apiService = ApiService();
  List<Rating> ratings = [];
  Map<String, String> authorNames = {};
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _ratingValue = 1.0;
  late User currentUser;
  bool _isLoading = false;
  Rating? _editingRating;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadUserRatings();
  }

  Future<void> _loadCurrentUser() async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      setState(() {
        currentUser = authState.user;
      });
    }
  }

  Future<void> _loadUserRatings() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedRatings = await apiService.fetchUserRatings(widget.user.id ?? '');
      for (var rating in fetchedRatings) {
        final author = await apiService.fetchUserByID(rating.authorId);
        authorNames[rating.authorId] = author.name;
      }
      setState(() {
        ratings = fetchedRatings
          ..sort((a, b) => (b.authorId ?? '').compareTo(currentUser.id ?? ''));
      });
      print("Ratings loaded successfully");
    } catch (error) {
      print("Error loading ratings: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Échec du chargement des évaluations: $error"),
        duration: const Duration(milliseconds: 1500),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitRating() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_editingRating != null) {
          final updatedRating = Rating(
            id: _editingRating!.id,
            mark: _ratingValue.toInt(),
            comment: _commentController.text,
            userId: _editingRating!.userId,
            authorId: _editingRating!.authorId,
          );
          await apiService.updateRating(updatedRating);
        } else {
          final newRating = Rating(
            id: 0,
            mark: _ratingValue.toInt(),
            comment: _commentController.text,
            userId: widget.user.id ?? '',
            authorId: '',
          );
          await apiService.createRating(newRating);
        }
        _loadUserRatings();
        _commentController.clear();
        setState(() {
          _editingRating = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Évaluation ajoutée avec succès"),
          duration: const Duration(milliseconds: 1500),
        ));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Échec de l'ajout de l'évaluation: $error"),
          duration: const Duration(milliseconds: 1500),
        ));
      }
    }
  }

  Future<void> _deleteRating(Rating rating) async {
    try {
      await apiService.deleteRating(rating.id);
      _loadUserRatings();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Évaluation supprimée avec succès"),
        duration: const Duration(milliseconds: 1500),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Échec de la suppression de l'évaluation: $error"),
        duration: const Duration(milliseconds: 1500),
      ));
    }
  }

  void _startEditing(Rating rating) {
    setState(() {
      _editingRating = rating;
      _commentController.text = rating.comment;
      _ratingValue = rating.mark.toDouble();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de ${widget.user.name}'),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.all(3),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Commentaires',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: ratings.length,
                        itemBuilder: (context, index) {
                          if (index < 0 || index >= ratings.length) {
                            print("Invalid index: $index");
                            return Container();
                          }
                          final rating = ratings[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(rating.comment),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        RatingBarIndicator(
                                          rating: rating.mark.toDouble(),
                                          itemBuilder: (context, index) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 20.0,
                                          direction: Axis.horizontal,
                                        ),
                                        const SizedBox(width: 10),
                                        Text('${rating.mark} étoiles'),
                                      ],
                                    ),
                                    Text('Par: ${authorNames[rating.authorId] ?? 'Inconnu'}'),
                                  ],
                                ),
                                trailing: rating.authorId == currentUser.id
                                    ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.orange),
                                      onPressed: () => _startEditing(rating),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.orange),
                                      onPressed: () => _deleteRating(rating),
                                    ),
                                  ],
                                )
                                    : null,
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey[300], // Gris clair
                                height: 10, // Hauteur du diviseur
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ajouter une évaluation',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.orange[100]!,
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: TextFormField(
                                    controller: _commentController,
                                    decoration: InputDecoration(
                                      labelText: 'Commentaire',
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer un commentaire';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RatingBar.builder(
                                  initialRating: _ratingValue,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _ratingValue = rating;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.orange[100],
                                      padding: const EdgeInsets.all(15),
                                    ),
                                    onPressed: _submitRating,
                                    child: const Text('Soumettre'),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
