import 'package:flutter/material.dart';
import 'package:purrfectmatch/views/insideModalFilter.dart';

class FilterModalWidget extends StatelessWidget {
  const FilterModalWidget({super.key, required this.callback});
  final Future<void> Function(String?, String?, int?) callback;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return InsideModalFilter(callback: callback);
          },
        );
      },
      icon: const Icon(Icons.filter_alt),
      label: const Text('Filter'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10)
      ),
    );
  }
}
