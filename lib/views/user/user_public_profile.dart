import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/user.dart';
import '../../models/rating.dart';
import '../../services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc.dart';

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
    try {
      final fetchedRatings = await apiService.fetchUserRatings(widget.user.id ?? '');
      for (var rating in fetchedRatings) {
        final author = await apiService.fetchUserByID(rating.authorId);
        authorNames[rating.authorId] = author.name;
      }
      setState(() {
        ratings = fetchedRatings;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Échec du chargement des évaluations: $error"),
        duration: const Duration(milliseconds: 1500),
      ));
    }
  }

  Future<void> _submitRating() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newRating = Rating(
          id: 0, // ID will be assigned by the backend
          mark: _ratingValue.toInt(),
          comment: _commentController.text,
          userId: widget.user.id ?? '',
          authorId: currentUser.id ?? '', // Use the current user's ID as the author
        );
        await apiService.createRating(newRating);
        _loadUserRatings(); // Refresh the list of ratings
        _commentController.clear();
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amberAccent[100]!, Colors.orange[400]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Commentaires',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: ratings.length,
                        itemBuilder: (context, index) {
                          final rating = ratings[index];
                          return ListTile(
                            title: Text(rating.comment),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: rating.mark.toDouble(),
                                      itemBuilder: (context, index) => Icon(
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
                                Text('Par: ${authorNames[rating.authorId] ?? 'Inconnu'}'), // Affiche le nom de l'auteur
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Ajouter une évaluation:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _commentController,
                            decoration: InputDecoration(labelText: 'Commentaire'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un commentaire';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          RatingBar.builder(
                            initialRating: _ratingValue,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(
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
                          ElevatedButton(
                            onPressed: _submitRating,
                            child: Text('Soumettre'),
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
      ),
    );
  }
}
