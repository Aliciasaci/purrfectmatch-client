import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'annonce/annonces_liste.dart';
import 'cat/cats_liste.dart';
import 'annonce/form_add_annonce.dart';
import 'cat/form_add_cat.dart';
import 'user/user_annonces.dart';
import 'user/user_favoris.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../models/user.dart';

class AnnoncesCatsMenu extends StatelessWidget {
  const AnnoncesCatsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          User? currentUser;
          if (state is AuthAuthenticated) {
            currentUser = state.user;
          }

          return ListView(
            padding: const EdgeInsets.all(10.0),
            children: [
              _buildCard(
                context,
                title: AppLocalizations.of(context)!.monCompte,
                children: [
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.announcements,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color set to white
                      ),
                    ),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.add,
                    text: AppLocalizations.of(context)!.createAnnouncement,
                    page: const AddAnnonce(),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.assignment,
                    text: AppLocalizations.of(context)!.myAnnouncements,
                    page: const UserAnnoncesPage(),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.favorite,
                    text: AppLocalizations.of(context)!.myFavorites,
                    page: const UserFavorisPage(),
                  ),
                  const Divider(color: Colors.white), // Divider color set to white
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.cats,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color set to white
                      ),
                    ),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.add,
                    text: AppLocalizations.of(context)!.addCat,
                    page: const AddCat(),
                  ),
                  if (currentUser != null)
                    _buildListTile(
                      context,
                      icon: Icons.pets,
                      text: AppLocalizations.of(context)!.myCats,
                      page: CatsListPage(userId: currentUser.id),
                    ),
                ],
              ),
              _buildCard(
                context,
                title: AppLocalizations.of(context)!.global,
                children: [
                  _buildListTile(
                    context,
                    icon: Icons.pets,
                    text: AppLocalizations.of(context)!.viewAllCats,
                    page: const CatsListPage(),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.list,
                    text: AppLocalizations.of(context)!.viewAllAnnouncements,
                    page: const AnnoncesListPage(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required List<Widget> children, IconData? icon, Widget? page}) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 10),
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
                      color: Colors.white, // Text color set to white
                    ),
                  ),
                ),
                const Divider(color: Colors.white), // Divider color set to white
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

  Widget _buildListTile(BuildContext context, {required IconData icon, required String text, required Widget page}) {
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
