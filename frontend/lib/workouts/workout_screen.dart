import 'package:flutter/material.dart';
import 'package:frontend/providers/workout_provider.dart';
import 'package:frontend/widgets/workout_card.dart';
import 'package:provider/provider.dart';

class WorkoutListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("WOD's"),
        automaticallyImplyLeading: true, // This enables the back button
      ),
      body: ListView.builder(
        itemCount: workoutProvider.workouts.length,
        itemBuilder: (context, index) {
          final workout = workoutProvider.workouts[index];
          return WorkoutCard(
            workout: workout,
            onMarkAsDone: () {
              workoutProvider.toggleMarkAsDone(index);
            },
          );
        },
      ),
    );
  }
}
