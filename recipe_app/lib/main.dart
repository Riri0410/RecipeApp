import 'package:flutter/material.dart';
import 'package:recipe_app/screens/homepage.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Recipe Finder',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
    ),
  );
}
