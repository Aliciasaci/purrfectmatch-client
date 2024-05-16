import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:purrfectmatch/modals/content.dart';

class SwipeCardsWidget extends StatefulWidget {
  const SwipeCardsWidget({super.key});
  @override
  _SwipeCardsWidgetState createState() => _SwipeCardsWidgetState();
}

class _SwipeCardsWidgetState extends State<SwipeCardsWidget> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  List<String> _names = [
    "Red",
    "Blue",
    "Blue",
    "Blue",
    "Blue",
    "Blue",
  ];
  List<String> _imageUrls = [
    "https://i0.wp.com/katzenworld.co.uk/wp-content/uploads/2019/06/funny-cat.jpeg?fit=1920%2C1920&ssl=1",
    "https://media.gettyimages.com/id/146582583/fr/photo/cat-sandwich.jpg?s=612x612&w=gi&k=20&c=8S_TreIUX3LHbYojsZpYT4A5F6fZs9gT8VeXNRJeGiQ=",
    "https://media.gettyimages.com/id/146582583/fr/photo/cat-sandwich.jpg?s=612x612&w=gi&k=20&c=8S_TreIUX3LHbYojsZpYT4A5F6fZs9gT8VeXNRJeGiQ=",
    "https://i.pinimg.com/736x/14/1f/67/141f675b8ddac4a80ca16d33cc9b34bf.jpg",
    "https://i0.wp.com/katzenworld.co.uk/wp-content/uploads/2019/06/funny-cat.jpeg?fit=1920%2C1920&ssl=1",
    "https://i0.wp.com/katzenworld.co.uk/wp-content/uploads/2019/06/funny-cat.jpeg?fit=1920%2C1920&ssl=1",
  ];

  @override
  void initState() {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(text: _names[i], image: _imageUrls[i]),
          likeAction: () { // like l'animal
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("like ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Nope ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          superlikeAction: () { // si super like alors voir l'animal
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Voir ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 600,
            width: 360,
            child: SwipeCards(
              matchEngine: _matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    _imageUrls[index],
                    fit: BoxFit.cover,
                    height: 600,
                  ),
                );
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Stack Finished"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              itemChanged: (SwipeItem item, int index) {
                print("item: ${item.content.text}, index: $index");
              },
              leftSwipeAllowed: true,
              rightSwipeAllowed: true,
              upSwipeAllowed: true,
              fillSpace: true,
            ),
          ),
          SizedBox(height: 10),
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
