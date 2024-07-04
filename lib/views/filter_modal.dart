import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purrfectmatch/views/insideModalFilter.dart';



class FilterModalWidget extends StatefulWidget {
  const FilterModalWidget({super.key});

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

// TODO: Appel d'une async function pour récupérer les races de chats. La fonction doit renvoyer une map avec une valeur vide.

class _FilterModalWidgetState extends State<FilterModalWidget> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton.small(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return const InsideModalFilter();
            },
          );
        },
      ),
    );
  }
}
