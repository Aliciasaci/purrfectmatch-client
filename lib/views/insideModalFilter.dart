import 'dart:ffi';

import 'package:flutter/material.dart';

import '../services/api_service.dart';

enum CatSex { femelle, male }

class InsideModalFilter extends StatefulWidget {
  const InsideModalFilter({super.key});

  @override
  State<InsideModalFilter> createState() => _InsideModalFilterState();
}

class _InsideModalFilterState extends State<InsideModalFilter> {
  static Map<int?, String> raceList = {};
  CatSex? _catSex = CatSex.femelle;
  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    _fetchCatRaces();
  }

  Future<void> _fetchCatRaces() async {
    //setState(() {
    //  _loading = true;
    //});

    try {
      final apiService = ApiService();
      final newRaces = await apiService.fetchAllRaces();
      for (var race in newRaces) {
        raceList[race.id] = race.raceName;
      }
      print(raceList);
    } catch (e) {
      print(raceList);
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
                hint: const Text('Sélectionner une race'),
                  items: raceList.map((id, race) {
                    return MapEntry(
                        id,
                        DropdownMenuItem<String>(
                          value: race,
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
  }
}
