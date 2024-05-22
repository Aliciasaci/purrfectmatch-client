import 'package:flutter/material.dart';
import '../models/cat.dart';
import '../services/api_service.dart';

class CatProfile extends StatefulWidget {
  const CatProfile({super.key});

  @override
  State<CatProfile> createState() => _CatProfileState();
}

class _CatProfileState extends State<CatProfile> {
  Cat? catData;

  @override
  void initState() {
    super.initState();
    _fetchCatData();
  }

  Future<void> _fetchCatData() async {
    try {
      Cat cat = await ApiService().fetchCatProfile();
      setState(() {
        catData = cat;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil du chat'),
      ),
      body: catData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom: ${catData!.name}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Date de Naissance: ${catData!.birthDate}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Date du dernier vaccin: ${catData!.lastVaccineDate}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Nom du dernier vaccin: ${catData!.lastVaccineName}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Couleur: ${catData!.color}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Comportement: ${catData!.behavior}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Race: ${catData!.race}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Description: ${catData!.description}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Genre: ${catData!.gender}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Stérilisé: ${catData!.sterilized ? 'Oui' : 'Non'}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Réservé: ${catData!.reserved ? 'Oui' : 'Non'}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}