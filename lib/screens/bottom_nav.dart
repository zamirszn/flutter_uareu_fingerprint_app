import 'package:fingerprint_app/data_source/database_helper.dart';
import 'package:fingerprint_app/screens/match_page.dart';
import 'package:fingerprint_app/screens/records_page.dart';
import 'package:fingerprint_app/screens/scan_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentPageIndex = 0;
  changePageIndex(index) {
    currentPageIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    initializeDatabase();
    super.initState();
  }

  void initializeDatabase() async {
    await dbHelper.initDatabase();
    if (kDebugMode) {
      print('Database initialized');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeScreens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) => changePageIndex(index),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.fingerprint_rounded), label: "Scan"),
            NavigationDestination(icon: Icon(Icons.search), label: "Match"),
            NavigationDestination(icon: Icon(Icons.storage), label: "Records"),
          ]),
    );
  }
}

List<Widget> homeScreens = [
  const ScanPage(),
  const MatchPage(),
  const RecordsPage(),
];
