import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';

// for searching items

class SearchTabScreen extends StatefulWidget {
  final User user;

  const SearchTabScreen({super.key, required this.user});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Search";

  @override
  void initState() {
    super.initState();
    print("Search");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
    );
  }
}
