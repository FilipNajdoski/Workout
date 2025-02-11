import 'package:flutter/material.dart';
import 'package:frontend/widgets/step_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pedometer/pedometer.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _steps = 0;
  int max_steps = 10000;
  String name = "";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _initStepCounter();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPreferencesJson = prefs.getString('userPreferences');

    if (userPreferencesJson != null) {
      Map<String, dynamic> userPreferences = json.decode(userPreferencesJson);

      setState(() {
        name = userPreferences['name'] ?? "N/A";
        max_steps = userPreferences['averageDailySteps'] ?? 10000;
      });
    }
  }

  void _initStepCounter() {
    // use this for production (not tested)
    // Pedometer.stepCountStream.listen((StepCount event) {
    //   setState(() {
    //     _steps = event.steps;
    //   });
    // }, onError: (error) {
    //   print("Step Counter Error: $error");
    // });

    //following code is for testing puroses
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _steps += 5; // Simulate 5 steps every second
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Welcome, $name!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StepCounterWidget(
                steps: _steps,
                maxSteps: max_steps,
                title: "Daily steps",
              ),
              StepCounterWidget(
                steps: 1,
                maxSteps: 7,
                title: "WOD completed",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
