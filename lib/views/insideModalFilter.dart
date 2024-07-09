import 'dart:ffi';

import 'package:flutter/material.dart';

import '../services/api_service.dart';

class InsideModalFilter extends StatefulWidget {
  const InsideModalFilter({super.key, required this.callback});
  final Future<void> Function(String? age, String? catSex, int? race) callback;

  @override
  State<InsideModalFilter> createState() => _InsideModalFilterState();
}

class _InsideModalFilterState extends State<InsideModalFilter> {
  Map<int?, String> raceList = {};
  String? _catSex = "";
  int? _dropdownValue;
  String? _age;

  @override
  void initState() {
    super.initState();
    _fetchCatRaces();
  }

  Future<void> _fetchCatRaces() async {
    try {
      final apiService = ApiService();
      final newRaces = await apiService.fetchAllRaces();
      for (var race in newRaces) {
        raceList[race.id] = race.raceName;
      }
      setState(() {
        raceList = raceList;
      });
    } catch (e) {
      print('Failed to load races: $e');
    }
    }

  @override
  Widget build(BuildContext context) {
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
              const Text(
                  "Filtres",
                  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900) ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Age du chat',
                  border: OutlineInputBorder(),
                ),
                autocorrect: false,
                maxLength: 2,
                onChanged: (text) {
                  setState(() {
                    _age = text;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('M'),
                      leading: Radio<String>(
                        value: "male",
                        groupValue: _catSex,
                        onChanged: (String? value) {
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
                      leading: Radio<String>(
                        value: "femelle",
                        groupValue: _catSex,
                        onChanged: (String? value) {
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
                hint: const Text('Sélectionner une race'),
                  items: raceList.entries.map((entry) {
                    return DropdownMenuItem<dynamic>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                  }).toList(),
                  value: _dropdownValue,
                  onChanged: (dynamic newValue) {
                    if (newValue != null) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    }
                  }),
              ElevatedButton(
                child: const Text('Lancer la recherche'),
                onPressed: () => {
                  widget.callback(_age, _catSex, _dropdownValue),
                  Navigator.pop(context)},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
