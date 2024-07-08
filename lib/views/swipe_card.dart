import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/models/annonce.dart';
import 'package:purrfectmatch/models/cat.dart';
import 'package:purrfectmatch/views/cat_detail_page.dart';

class SwipeCardsWidget extends StatefulWidget {
  const SwipeCardsWidget({super.key});
  @override
  _SwipeCardsWidgetState createState() => _SwipeCardsWidgetState();
}

class _SwipeCardsWidgetState extends State<SwipeCardsWidget> {
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    apiService.fetchAllAnnonces().then((annonces) async {
      for (var annonce in annonces) {
        try {
          Cat cat = await apiService.fetchCatByID(annonce.CatID);
          _swipeItems.add(SwipeItem(
            content: {'annonce': annonce, 'cat': cat},
            likeAction: () {
              print("annonceID");
              print(annonce.ID);
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
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to load annonces: $error"),
        duration: const Duration(milliseconds: 1500),
      ));
    });
  }

  void _handleLikeAction(int? annonceID, String catName) {
    print("annonceID2");
    print(annonceID);

    apiService.createFavorite(annonceID).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ajout de $catName à tes favoris"),
        duration: const Duration(milliseconds: 500),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to like $catName: $error"),
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
    double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Container(
      //color: Colors.red,
      height: availableHeight,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_matchEngine == null)
            const CircularProgressIndicator()
          else
            SizedBox(
              height: availableHeight * 0.7,
              width: 360,
              child: SwipeCards(
                matchEngine: _matchEngine!,
                itemBuilder: (BuildContext context, int index) {
                  var item = _swipeItems[index].content as Map;
                  Annonce annonce = item['annonce'] as Annonce;
                  Cat cat = item['cat'] as Cat;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.network(
                          cat.picturesUrl.first,
                          fit: BoxFit.cover,
                          height: 600,
                          width: 360,
                        ),
                        Container(
                          height: 600,
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
                          padding: const EdgeInsets.all(20),
                          height: 600,
                          width: 360,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${calculateAge(cat.birthDate)} ans",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Sexe: ${cat.sexe}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Race: ${cat.race}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              if (!cat.reserved)
                                const Text(
                                  "Disponible",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (cat.reserved)
                                const Text(
                                  "Réservé",
                                  style: TextStyle(
                                    color: Colors.red,
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
                    content: Text("Stack Finished"),
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
          Positioned(
            bottom: 10,
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  left: 10,
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          _matchEngine!.currentItem?.nope();
                        },
                        icon: const Icon(Icons.close),
                        iconSize: 60,
                        color: Colors.white,
                        tooltip: 'Passer',
                        padding: const EdgeInsets.all(20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        _matchEngine!.currentItem?.superLike();
                      },
                      icon: const Icon(Icons.visibility),
                      iconSize: 60,
                      color: Colors.white,
                      tooltip: 'Voir',
                      padding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          _matchEngine!.currentItem?.like();
                        },
                        icon: const Icon(Icons.favorite),
                        iconSize: 60,
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        tooltip: 'Favoris',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
