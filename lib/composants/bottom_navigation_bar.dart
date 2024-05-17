import 'package:flutter/material.dart';
import 'package:purrfectmatch/screens/profile/profile_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    this.onItemTapped,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.00),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.withOpacity(0.5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:_buildIcon(Icons.search, 0, Colors.green),
              label: 'Chercher',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.pets, 1, Colors.pink),
              label: 'Faire adopter',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: _buildIcon(Icons.supervised_user_circle, 2, Colors.amber),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ), label: 'Profil'
            ),
          ],
          currentIndex: widget.selectedIndex,
          onTap: widget.onItemTapped,
        ),
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index, Color color) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            iconData,
            color: color,
          ),
        ),
        if (widget.selectedIndex == index)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
            ),
          )
      ],
    );
  }
}
