import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String name = "";
  int age = 0;
  String fitnessLevel = "";
  String goal = "";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPreferencesJson = prefs.getString('userPreferences');

    if (userPreferencesJson != null) {
      Map<String, dynamic> userPreferences = json.decode(userPreferencesJson);

      setState(() {
        name = userPreferences['name'] ?? "N/A";
        age = userPreferences['age'] ?? 0;
        fitnessLevel = userPreferences['fitnessLevel'] ?? "N/A";
        goal = userPreferences['goal'] ?? "N/A";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, $name!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Age: $age", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Fitness Level: $fitnessLevel",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Goal: $goal", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
