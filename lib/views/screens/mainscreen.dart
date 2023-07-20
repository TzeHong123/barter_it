//import 'package:barter_it/views/screens/OfferTab/Offertabscreen.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/views/screens/ProfileTab/profiletabscreen.dart';
import 'package:barter_it/views/screens/SearchTab/Searchtabscreen.dart';

import '../../models/user.dart';
import 'InventoryTab/Inventorytabscreen.dart';
import 'ChatTab/Chattabscreen.dart';

//Main screen

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Offer";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("Mainscreen");
    tabchildren = [
      OfferTabScreen(
        user: widget.user,
      ),
      SearchTabScreen(user: widget.user),
      ProfileTabScreen(user: widget.user),
      ChatTabScreen(user: widget.user)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.inventory,
                ),
                label: "Inventory"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble_outline_outlined,
                ),
                label: "Chat")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Offer";
      }
      if (_currentIndex == 1) {
        maintitle = "Search";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
      if (_currentIndex == 3) {
        maintitle = "Chat";
      }
    });
  }
}
