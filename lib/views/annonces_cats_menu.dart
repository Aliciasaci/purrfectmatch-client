import 'package:flutter/material.dart';
import 'annonce/annonces_liste.dart';
import 'cat/cats_liste.dart';
import 'annonce/form_add_annonce.dart';
import 'cat/form_add_cat.dart';
import 'user/user_annonces.dart';
import 'user/user_favoris.dart';

class AnnoncesCatsMenu extends StatelessWidget {
  const AnnoncesCatsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          _buildCard(
            context,
            title: 'Chats',
            children: [
              _buildListTile(
                context,
                icon: Icons.pets,
                text: 'Voir tous les chats',
                page: CatsListPage(),
              ),
              _buildListTile(
                context,
                icon: Icons.add,
                text: 'Ajouter un chat',
                page: AddCat(),
              ),
            ],
          ),
          _buildCard(
            context,
            title: 'Annonces',
            children: [
              _buildListTile(
                context,
                icon: Icons.list,
                text: 'Voir toutes les annonces',
                page: AnnoncesListPage(),
              ),
              _buildListTile(
                context,
                icon: Icons.add,
                text: 'Créer une annonce',
                page: AddAnnonce(),
              ),
            ],
          ),
          _buildCard(
            context,
            title: 'Utilisateur',
            children: [
              _buildListTile(
                context,
                icon: Icons.assignment,
                text: 'Mes annonces',
                page: UserAnnoncesPage(),
              ),
              _buildListTile(
                context,
                icon: Icons.favorite,
                text: 'Mes favoris',
                page: UserFavorisPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String text, required Widget page}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
