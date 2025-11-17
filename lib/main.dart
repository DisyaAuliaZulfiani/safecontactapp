import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';

void main() {
  // Wajib menggunakan ProviderScope untuk Riverpod
  runApp(const ProviderScope(child: SafeContactApp()));
}

class SafeContactApp extends StatelessWidget {
  const SafeContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeContact Darurat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00ADB5), // Primary Color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFF2E63), // Accent Color
        ),
        fontFamily: 'Roboto', // Font umum yang bersih
      ),
      home: const HomeScreen(),
    );
  }
}