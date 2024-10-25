import 'package:flutter/material.dart';

class BarMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BarMenu({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.photo),
          label: 'Picture',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_album),
          label: 'Album',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blueAccent,
      onTap: onItemTapped,
    );
  }
}
