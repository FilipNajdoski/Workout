import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  DashboardScreen({required this.onThemeChanged});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
              widget.onThemeChanged(isDarkMode);
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome to Dashboard!"),
      ),
    );
  }
}
