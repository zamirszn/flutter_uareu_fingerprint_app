import 'package:fingerprint_app/screens/bottom_nav.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FingerPrintApp());
}

class FingerPrintApp extends StatelessWidget {
  const FingerPrintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "FingerPrint",
        darkTheme: ThemeData.dark(
          
        ),
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            fontFamily: "PulpDisplay"),
        debugShowCheckedModeBanner: false,
        home: const BottomNav());
  }
}
