

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
          bottom: Radius.circular(0),
        ),
        color: Colors.white,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Filtres",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange[100]!,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Age du chat',
                    border: InputBorder.none,
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(2)],
                  onChanged: (text) {
                    setState(() {
                      _age = text;
                    });
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('M'),
                      leading: Radio<String>(
                        value: "Male",
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
                        value: "Female",
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
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange[100],
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text('Lancer la recherche'),
                onPressed: () => {
                  widget.callback(_age, _catSex, _dropdownValue),
                  Navigator.pop(context)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
