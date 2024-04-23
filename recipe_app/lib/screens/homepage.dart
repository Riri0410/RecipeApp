import 'package:flutter/material.dart';
import 'package:recipe_app/screens/appInfo.dart';
import 'package:recipe_app/screens/chatbot.dart';
import 'package:recipe_app/screens/homepageContent.dart';
import 'package:recipe_app/screens/savedRecipesPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    // ChatBot(),
    HomePageContent(),
    AppInfoPage(),
  ];

  final List<String> appBarTitles = [
    // 'AI Chatbot',
    'Generate Recipe',
    'App Info',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitles[_currentIndex],
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat_bubble),
          //   label: 'AI Chatbot',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Generate Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'App Info',
          ),
        ],
      ),
    );
  }
}
