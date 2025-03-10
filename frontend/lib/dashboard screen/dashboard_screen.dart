import 'package:flutter/material.dart';
import 'package:frontend/providers/workout_provider.dart';
import 'package:frontend/widgets/step_counter.dart';
import 'package:frontend/widgets/workout_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _steps = 0;
  int max_steps = 10000;
  String name = "";
  int workoutDaysPerWeek = 7;
  DateTime selectedDate = DateTime.now();

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
        workoutDaysPerWeek = userPreferences['workoutDaysPerWeek'] ?? 7;
      });
    }
  }

  void _initStepCounter() {
    // use this for production (not tested)
    Pedometer.stepCountStream.listen((StepCount event) {
      setState(() {
        _steps = event.steps;
      });
    }, onError: (error) {
      print("Step Counter Error: $error");
    });

    //following code is for testing puroses
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _steps += 5; // Simulate 5 steps every second
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final filteredWorkouts = workoutProvider.workouts
        .where((workout) => workout.dateAssigned == selectedDate)
        .toList();

    final dailyWorkout =
        filteredWorkouts.isNotEmpty ? filteredWorkouts.first : null;
    // Find the index in the original list
    final workoutIndex = dailyWorkout != null
        ? workoutProvider.workouts
            .indexWhere((workout) => workout == dailyWorkout)
        : -1;

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
                maxSteps: workoutDaysPerWeek,
                title: "Workout Days",
              ),
            ],
          ),
          SizedBox(height: 30),
          CalendarTimeline(
            initialDate: selectedDate,
            firstDate: DateTime(2023, 1, 1),
            lastDate: DateTime(2025, 12, 31),
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
              print("Selected date: $date");
            },
            leftMargin: 20,
            monthColor: Colors.blueGrey,
            dayColor: Colors.teal[200],
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.redAccent[100],
            dotColor: Color(0xFF333A47),
            selectableDayPredicate: (date) => date.day != 23,
            locale: 'en',
          ),
          dailyWorkout != null
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        WorkoutCard(
                            workout: dailyWorkout,
                            onMarkAsDone: () {
                              workoutProvider.toggleMarkAsDone(workoutIndex);
                            })
                      ],
                    ),
                  ),
                )
              : Text("No workout for selected date"),
        ],
      ),
    );
  }
}
