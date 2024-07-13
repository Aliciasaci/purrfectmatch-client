import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/cat.dart';
import 'edit_cat_details.dart';

class CatDetails extends StatelessWidget {
  final Cat cat;

  const CatDetails({super.key, required this.cat});

  String calculateAge(String birthDateString) {
    DateTime birthDate = DateTime.parse(birthDateString);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;

    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.catDetailsTitle),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amberAccent[100]!, Colors.orange[400]!],
          ),
        ),
        child: Center(
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        cat.picturesUrl.isNotEmpty ? cat.picturesUrl.first : 'https://via.placeholder.com/300',
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.birthDate}: ${cat.birthDate}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.age}: ${calculateAge(cat.birthDate)} ans',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.lastVaccineDate}: ${cat.lastVaccineDate}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.lastVaccineName}: ${cat.lastVaccineName}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.color}: ${cat.color}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.behavior}: ${cat.behavior}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.race}: ${cat.race}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.description}: ${cat.description}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.gender}: ${cat.sexe}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.sterilized}: ${cat.sterilized ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)!.reserved}: ${cat.reserved ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCatDetails(cat: cat),
                            ),
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.edit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
