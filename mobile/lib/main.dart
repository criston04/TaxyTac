import 'package:flutter/material.dart';
import 'screens/mode_selection_screen.dart';

void main() {
  runApp(const TaxyTacApp());
}

class TaxyTacApp extends StatelessWidget {
  const TaxyTacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaxyTac - Motos Bajaj',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const ModeSelectionScreen(),
    );
  }
}
