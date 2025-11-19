import 'package:flutter/material.dart';
import 'passenger_home_screen.dart';
import 'trip_history_screen.dart';
import 'profile_screen.dart';

class UberStyleMainScreen extends StatefulWidget {
  const UberStyleMainScreen({super.key});

  @override
  State<UberStyleMainScreen> createState() => _UberStyleMainScreenState();
}

class _UberStyleMainScreenState extends State<UberStyleMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    PassengerHomeScreen(),
    Center(child: Text('Opciones', style: TextStyle(fontSize: 24))),
    TripHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Opciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Actividad',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Cuenta',
            ),
          ],
        ),
      ),
    );
  }
}
