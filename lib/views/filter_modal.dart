import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purrfectmatch/views/test.dart';

enum CatSex { femelle, male }

class FilterModalWidget extends StatefulWidget {
  const FilterModalWidget({super.key});

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  static const Map<String, String> list = {'': 'Race', 'toto': 'toto1', 'tata': 'tata1', 'pepe': 'pepe1'};
  CatSex? _catSex = CatSex.femelle;
  String? _dropdownValue = 'aaaaaaaaaaaaa';


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
                height: 600,
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
                  child: Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Age du chat',
                            border: OutlineInputBorder(),
                          ),
                          autocorrect: false,
                          maxLength: 2,
                        ),
                         Row(
                           children: [
                             Expanded(
                               child: ListTile(
                                 title: const Text('M'),
                                 leading: Radio<CatSex>(
                                   value: CatSex.male,
                                   groupValue: _catSex,
                                   onChanged: (CatSex? value) {
                                     setState(() {
                                       _catSex = value;
                                     });
                                   },
                                 ),
                               ),
                             ),
                             Expanded(
                               child: ListTile(
                                 title: const Text('F'),
                                 leading: Radio<CatSex>(
                                   value: CatSex.femelle,
                                   groupValue: _catSex,
                                   onChanged: (CatSex? value) {
                                     setState(() {
                                       _catSex = value;
                                     });
                                   },
                                 ),
                               ),
                             )
                           ],
                         ),
                        DropdownButton(
                            items: list.map((id, race) {
                              return MapEntry(
                                  id,
                                  DropdownMenuItem<String>(
                                value: id,
                                child: Text(race),
                              ));
                            }).values.toList(),
                            value: _dropdownValue,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _dropdownValue = newValue;
                                });
                              }
                            }),
                        ElevatedButton(
                          child: const Text('Lancer la recherche'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
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
