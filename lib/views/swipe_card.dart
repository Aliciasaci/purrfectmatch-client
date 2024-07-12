import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/models/annonce.dart';
import 'package:purrfectmatch/models/cat.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:purrfectmatch/views/cat/cat_details.dart';
import 'package:purrfectmatch/views/user/user_public_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/blocs/auth_bloc.dart';

import 'filter_modal.dart';

class SwipeCardsWidget extends StatefulWidget {
  const SwipeCardsWidget({super.key});

  @override
  _SwipeCardsWidgetState createState() => _SwipeCardsWidgetState();
}

class _SwipeCardsWidgetState extends State<SwipeCardsWidget> {
  static List<Annonce> _annonceList = [];
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadAnnonces();
  }

  Future<void> _loadAnnonces() async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      final currentUser = authState.user;
      try {
        final annonces = await apiService.fetchAllAnnonces();
        final filteredAnnonces =
        annonces.where((annonce) => annonce.UserID != currentUser.id).toList();

        for (var annonce in filteredAnnonces) {
          try {
            Cat cat = await apiService.fetchCatByID(annonce.CatID);
            if (!cat.reserved) {
              User user = await apiService.fetchUserByID(annonce.UserID);
              print(annonce.UserID);

              _swipeItems.add(SwipeItem(
                content: {'annonce': annonce, 'cat': cat, 'user': user},
                likeAction: () {
                  _handleLikeAction(annonce.ID, cat.name);
                },
                nopeAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Passé ${cat.name}"),
                    duration: const Duration(milliseconds: 500),
                  ));
                },
                superlikeAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CatDetails(cat: cat)),
                  );
                },
              ));
            }
          } catch (error) {
            print(
                "Échec du chargement des données pour l'annonce ${annonce.ID}: $error");
          }
        }

        setState(() {
          _matchEngine = MatchEngine(swipeItems: _swipeItems);
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Échec du chargement des annonces: $error"),
          duration: const Duration(milliseconds: 1500),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Utilisateur non authentifié"),
        duration: const Duration(milliseconds: 1500),
      ));
    }
  }

  Future<void> fetchCatsByFilters(String? age, String? catSex, int? race) async {
    try {
      final List<Annonce> annoncesList = [];
      final filteredAnnonce =
      await apiService.fetchCatsByFilters(age, catSex, race);
      for (var annonce in filteredAnnonce) {
        annoncesList.add(annonce);
      }
      setState(() {
        _annonceList = annoncesList;
        _matchEngine = null;
      });
      _swipeItems.clear();
      displayCats(_annonceList);
    } catch (e) {
      print('Failed to load cats with filter: $e');
    }
  }

  Future<void> displayCats(List<Annonce> annonces) async {
    for (var annonce in annonces) {
      try {
        Cat cat = await apiService.fetchCatByID(annonce.CatID);
        User user = await apiService.fetchUserByID(annonce.UserID);
        _swipeItems.add(SwipeItem(
          content: {'annonce': annonce, 'cat': cat, 'user': user},
          likeAction: () {
            _handleLikeAction(annonce.ID, cat.name);
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Passed ${cat.name}"),
              duration: const Duration(milliseconds: 500),
            ));
          },
          superlikeAction: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CatDetails(cat: cat)),
            );
          },
        ));
      } catch (error) {
        print("Failed to load cat for annonce ${annonce.ID}: $error");
      }
    }

    setState(() {
      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
  }

  void _handleLikeAction(int? annonceID, String catName) {
    apiService.createFavorite(annonceID).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ajout de $catName à tes favoris"),
        duration: const Duration(milliseconds: 500),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Échec de l'ajout de $catName aux favoris: $error"),
        duration: const Duration(milliseconds: 1500),
      ));
    });
  }

  String calculateAge(String birthDateString) {
    DateTime birthDate = DateTime.parse(birthDateString);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;

    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_matchEngine == null)
            const CircularProgressIndicator()
          else
            FilterModalWidget(callback: fetchCatsByFilters),
          SizedBox(
            height: 580,
            width: 360,
            child: SwipeCards(
              matchEngine: _matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                var item = _swipeItems[index].content as Map;
                Annonce annonce = item['annonce'] as Annonce;
                Cat cat = item['cat'] as Cat;
                User user = item['user'] as User;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.network(
                        cat.picturesUrl.first,
                        fit: BoxFit.cover,
                        height: 580,
                        width: 360,
                      ),
                      Container(
                        height: 580,
                        width: 360,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: 580,
                        width: 360,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${calculateAge(cat.birthDate)} ans",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Sexe: ${cat.sexe}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Race: ${cat.race}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserPublicProfile(user: user)),
                                  );
                                },
                                child: Text(
                                  "Mise en ligne par: ${user.name}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 2,
                                    height:
                                    1.5, // This will add some space between the text and the underline
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Disponible",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Pile terminée"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              itemChanged: (SwipeItem item, int index) {
                var itemContent = item.content as Map;
                Annonce annonce = itemContent['annonce'] as Annonce;
                Cat cat = itemContent['cat'] as Cat;
                print("item: ${cat.name}, index: $index");
              },
              leftSwipeAllowed: true,
              rightSwipeAllowed: true,
              upSwipeAllowed: true,
              fillSpace: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: () {
                    _matchEngine!.currentItem?.nope();
                  },
                  icon: const Icon(Icons.close),
                  iconSize: 40,
                  color: Colors.red.withOpacity(0.8),
                  tooltip: 'Passer',
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: () {
                    _matchEngine!.currentItem?.superLike();
                  },
                  icon: const Icon(Icons.visibility),
                  iconSize: 40,
                  color: Colors.orange.withOpacity(0.8),
                  tooltip: 'Voir',
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: () {
                    _matchEngine!.currentItem?.like();
                  },
                  icon: const Icon(Icons.favorite),
                  iconSize: 40,
                  color: Colors.green.withOpacity(0.8),
                  tooltip: 'Favoris',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
