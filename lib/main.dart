import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NatureScannerApp());
}

class NatureScannerApp extends StatelessWidget {
  const NatureScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nature Scanner',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
