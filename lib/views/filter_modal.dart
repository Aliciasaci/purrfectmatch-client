import 'package:flutter/material.dart';

class FilterModalWidget extends StatefulWidget {
  const FilterModalWidget({super.key});

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

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
              return Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                    bottom: Radius.circular(0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.amberAccent[100]!, Colors.orange[400]!],
                  ),
                ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Ceci est une modale'),
                        ElevatedButton(
                          child: const Text('Lancer la recherche'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
              );
            },
          );
        },
      ),
    );
  }
}
