
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/api_service.dart';

class InsideModalFilter extends StatefulWidget {
  const InsideModalFilter({super.key, required this.callback});
  final Future<void> Function(String? age, String? catSex, int? race, int? asso) callback;

  @override
  State<InsideModalFilter> createState() => _InsideModalFilterState();
}

class _InsideModalFilterState extends State<InsideModalFilter> {
  Map<int?, String> raceList = {};
  Map<int?, String> assoList = {};
  String? _catSex = "";
  int? _dropdownValueRace;
  int? _dropdownValueAsso;
  String? _age;
  String _placeHolderAsso = "";
  String _placeHolderRace = "";

  @override
  void initState() {
    super.initState();
    _fetchCatRaces();
    _fetchAssociation();
  }

  Future<void> _fetchCatRaces() async {
    try {
      final apiService = ApiService();
      final newRaces = await apiService.fetchAllRaces();
      if (newRaces.isEmpty) {
        setState(() {
          _placeHolderRace = AppLocalizations.of(context)!.noRaceFoundFilter;
        });
      }
      for (var race in newRaces) {
        raceList[race.id] = race.raceName;
      }
      setState(() {
        _placeHolderRace = AppLocalizations.of(context)!.selectRaceFilter;
        raceList = raceList;
      });
    } catch (e) {
      print('Failed to load races: $e');
    }
  }

  Future<void> _fetchAssociation() async {
    try {
      final apiService = ApiService();
      final newAsso = await apiService.fetchAllAssociations();
      print(newAsso);
      if (newAsso.isEmpty) {
        setState(() {
          _placeHolderAsso = AppLocalizations.of(context)!.noAssoFoundFilter;
        });
      } else {
        for (var asso in newAsso) {
          assoList[asso.ID] = asso.Name;
        }
        setState(() {
          _placeHolderAsso = AppLocalizations.of(context)!.selectAssoFilter;
          assoList = assoList;
        });
      }
    } catch(e) {
      print('Failed to load associations: $e');
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
               Text(AppLocalizations.of(context)!.filterLabel,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange[100]!,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.age,
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
                  hint: Text(_placeHolderRace),
                  items: raceList.entries.map((entry) {
                    return DropdownMenuItem<dynamic>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  value: _dropdownValueRace,
                  onChanged: (dynamic newValue) {
                    if (newValue != null) {
                      setState(() {
                        _dropdownValueRace = newValue;
                      });
                    }
                  }),
              DropdownButton(
                  hint: Text(_placeHolderAsso),
                  items: assoList.entries.map((entry) {
                    return DropdownMenuItem<dynamic>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  value: _dropdownValueAsso,
                  onChanged: (dynamic newValue) {
                    if (newValue != null) {
                      setState(() {
                        _dropdownValueAsso = newValue;
                      });
                    }
                  }),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange[100],
                  padding: const EdgeInsets.all(15),
                ),
                child: Text(AppLocalizations.of(context)!.filterSearch),
                onPressed: () => {
                  widget.callback(_age, _catSex, _dropdownValueRace, _dropdownValueAsso),
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
