import 'package:fingerprint_app/screens/scan_page.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeScreens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) => changePageIndex(index),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.fingerprint_rounded), label: "Scan"),
            // NavigationDestination(icon: Icon(Icons.cast), label: "Cast"),
            NavigationDestination(icon: Icon(Icons.storage), label: "Records"),
          ]),
    );
  }
}

List<Widget> homeScreens = [
  const ScanPage(),
  Container(),
];
