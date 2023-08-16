import 'package:flutter/material.dart';

import 'image_cat.dart';
import 'random_fact_page.dart';

void main() {
  runApp(const CatApp());
}

class CatApp extends StatefulWidget {
  const CatApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CatApp> {
  bool showRandomFactPage = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: showRandomFactPage
          ? RandomFactPage(changeToHomeScreen: () {
              setState(() {
                showRandomFactPage = false;
              });
            })
          : CatHomeScreen(changeToRandomFactPage: () {
              setState(() {
                showRandomFactPage = true;
              });
            }),
    );
  }
}
