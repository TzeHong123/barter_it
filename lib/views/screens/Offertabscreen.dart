import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';

//for Offer screen

class OfferTabScreen extends StatefulWidget {
  final User user;
  const OfferTabScreen({super.key, required this.user});

  @override
  State<OfferTabScreen> createState() => _OfferTabScreenState();
}

class _OfferTabScreenState extends State<OfferTabScreen> {
  String maintitle = "Offer";

  @override
  void initState() {
    super.initState();
    print("Offer");
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
