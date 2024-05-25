import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'views/bottom_navigation_bar.dart';
import 'views/swipe_card.dart';
import 'views/form_add_annonce.dart';
import 'views/login.dart';
import 'views/annonces_cats_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(scaffoldBackgroundColor: Colors.transparent),
      home: AuthService.authToken == null ? const LoginPage() : const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // List of widgets for each tab
  static const List<Widget> _widgetOptions = <Widget>[
    SwipeCardsWidget(),
    AnnoncesCatsMenu(),
    AddAnnonce(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    AuthService().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.amberAccent[100]!, Colors.orange[400]!],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Stack(
            children: [
              const Center(
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 30,
                  width: 30,
                ),
              ),
              Center(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
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
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
