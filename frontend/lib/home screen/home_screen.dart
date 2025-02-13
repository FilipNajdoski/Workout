import 'package:flutter/material.dart';
import 'package:frontend/dashboard%20screen/dashboard_screen.dart';
import 'package:frontend/utils/theme_manager.dart';
import 'package:frontend/workouts/workout_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    DashboardScreen(),
    WorkoutListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.lightGreenAccent;
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Dashboard' : 'Workouts'),
        actions: [
          Consumer<ThemeManager>(
            builder: (context, themeManager, child) {
              return IconButton(
                icon: Icon(
                  themeManager.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  themeManager.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        mini: true,
        shape: CircleBorder(),
        onPressed: () {
          // No action for now.
        },
        child: Image.asset(
          'assets/icons/dumbell.png',
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.dashboard,
                  color: _selectedIndex == 0 ? primaryColor : Colors.grey,
                ),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              SizedBox(width: 48.0),
              IconButton(
                icon: Image.asset(
                  'assets/icons/dumbells.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  color: _selectedIndex == 1 ? primaryColor : Colors.grey,
                ),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
