import 'package:flutter/material.dart';
import 'annonces_liste.dart';
import 'cats_liste.dart';
import 'form_add_annonce.dart';
import 'form_add_cat.dart';

class AnnoncesCatsMenu extends StatelessWidget {
  const AnnoncesCatsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text('Menu'),
      // ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Card(
            color: Colors.white,
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.pets),
                  title: const Text('Voir tous les chats'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CatsListPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Ajouter un chat'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCat()),
                    );
                  },
                ),
              ],
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    'Annonces',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Voir toutes les annonces'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnnoncesListPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Créer une annonce'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAnnonce()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
