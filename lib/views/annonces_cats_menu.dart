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
        padding: const EdgeInsets.all(20.0),
        children: [
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
          const SizedBox(height: 20),
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
            ],
            icon: Icons.add,
            page: AddCat(),
          ),
          const SizedBox(height: 20),
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
            ],
            icon: Icons.add,
            page: AddAnnonce(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required List<Widget> children,
      IconData? icon,
      Widget? page}) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFA7D82),
              Color(0xFFFFB295),
            ],
          ),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFFFB295).withOpacity(0.6),
                offset: const Offset(1.1, 4),
                blurRadius: 8.0)
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                ListTile(
                  title: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ...children,
              ],
            ),
            if (icon != null && page != null)
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(icon,
                        color: const Color(
                            0xFFFA7D82)), // Icon color matching the gradient start
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => page),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon, required String text, required Widget page}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
