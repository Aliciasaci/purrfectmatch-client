import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purrfectmatch/views/insideModalFilter.dart';



class FilterModalWidget extends StatefulWidget {
  const FilterModalWidget({super.key, required this.callback});
  final Future<void> Function(String?, String?, int?) callback;

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
              return InsideModalFilter(callback: widget.callback);
            },
          );
        },
      ),
    );
  }
}