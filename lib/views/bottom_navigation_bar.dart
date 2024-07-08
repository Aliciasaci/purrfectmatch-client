import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    this.onItemTapped,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.search, 0, Colors.green),
            label: 'Chercher',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.pets, 1, Colors.pink),
            label: 'Faire adopter',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.supervised_user_circle, 2, Colors.amber),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person, 3, Colors.blueAccent),
            label: 'Mon profil',
          ),
        ],
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
        selectedItemColor: Colors.black,
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index, Color color) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
