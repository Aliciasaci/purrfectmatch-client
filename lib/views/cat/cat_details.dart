import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import './edit_cat_details.dart';

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
    final authState = BlocProvider.of<AuthBloc>(context).state;
    final currentUser = authState is AuthAuthenticated ? authState.user : null;

    String formattedBirthDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(cat.birthDate));
    String formattedLastVaccineDate = cat.lastVaccineDate.isNotEmpty ? DateFormat('dd-MM-yyyy').format(DateTime.parse(cat.lastVaccineDate)) : 'N/A';

    Widget buildInfoBubble(String label, String value) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange[100]!),
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          '$label: $value',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    Widget buildCheckBubble(String label, bool value) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange[100]!),
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: const TextStyle(fontSize: 16),
            ),
            Icon(
              value ? Icons.check_circle : Icons.cancel,
              color: value ? Colors.green : Colors.red,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.catDetailsTitle),
        backgroundColor: Colors.orange[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[100]!, Colors.orange[200]!],
          ),
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          cat.picturesUrl.isNotEmpty
                              ? cat.picturesUrl.first
                              : 'https://via.placeholder.com/300',
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    if (cat.PublishedAs != null && cat.PublishedAs!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Proposé à l\'adoption par l\'association : ${cat.PublishedAs}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    buildInfoBubble(AppLocalizations.of(context)!.birthDate, formattedBirthDate),
                    buildInfoBubble(AppLocalizations.of(context)!.age, '${calculateAge(cat.birthDate)} ans'),
                    buildInfoBubble(AppLocalizations.of(context)!.lastVaccineDate, formattedLastVaccineDate),
                    buildInfoBubble(AppLocalizations.of(context)!.lastVaccineName, cat.lastVaccineName),
                    buildInfoBubble(AppLocalizations.of(context)!.color, cat.color),
                    buildInfoBubble(AppLocalizations.of(context)!.race, cat.raceID),
                    buildInfoBubble(AppLocalizations.of(context)!.description, cat.description),
                    buildInfoBubble(AppLocalizations.of(context)!.gender, cat.sexe),
                    buildCheckBubble(AppLocalizations.of(context)!.sterilized, cat.sterilized),
                    buildCheckBubble(AppLocalizations.of(context)!.reserved, cat.reserved),
                    const SizedBox(height: 20),
                    if (currentUser != null && cat.userId == currentUser.id)
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.all(15),
                          ),
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
