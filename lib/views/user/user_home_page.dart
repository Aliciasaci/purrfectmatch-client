import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/blocs/room/room_bloc.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/views/user/profile/profile_screen.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../models/user.dart';
import '../annonces_cats_menu.dart';
import '../bottom_navigation_bar.dart';
import '../annonce/form_add_annonce.dart';
import '../login.dart';
import '../swipe_card.dart';
import './room/rooms_list_screen.dart';
import 'package:provider/provider.dart';
import '../../locale_provider.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key, required this.title, this.user});
  final String title;
  final User? user;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const SwipeCardsWidget(),
    const AnnoncesCatsMenu(),
    const RoomsListScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);

    return Container(
      color: Colors.blue,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Stack(
            children: [
              const Image(
                image: AssetImage('assets/paw.png'),
                height: 30,
                width: 30,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          elevation: 0,
          actions: [

            GestureDetector(
              onTap: () {
                if (localeProvider.locale == const Locale('en')) {
                  localeProvider.setLocale(const Locale('fr'));
                } else {
                  localeProvider.setLocale(const Locale('en'));
                }
              },
              child: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(
                  localeProvider.locale == const Locale('fr')
                      ? 'assets/images/flag_fr.png'
                      : 'assets/images/flag_uk.png',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
