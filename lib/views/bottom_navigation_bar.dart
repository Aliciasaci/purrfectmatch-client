import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.search, 0, Colors.green),
            label: AppLocalizations.of(context)!.search,
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.pets, 1, Colors.pink),
            label: AppLocalizations.of(context)!.adopt,
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.message, 3, Colors.deepPurple),
            label: AppLocalizations.of(context)!.conversations,
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person, 4, Colors.blueAccent),
            label: AppLocalizations.of(context)!.profile,
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
            color: widget.selectedIndex == index ? color : Colors.grey,
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
          ),
      ],
    );
  }
}
