import 'package:flutter/material.dart';
import 'package:frontend/models/workout.dart';

class WorkoutProvider with ChangeNotifier {
  final List<Workout> _workouts = [
    Workout(
        mainTitle: "2013 CrossFit Games Open",
        group: "Advanced",
        wodTitle: "OPEN 13.2",
        wodType: "AMRAP",
        wodTime: "10 minutes",
        movements: [
          Movement(reps: 5, name: "Shoulder-to-Overheads", weight: "115/75 lb"),
          Movement(reps: 10, name: "Deadlifts", weight: "115/75 lb"),
          Movement(reps: 15, name: "Box Jumps", weight: "24/20 in"),
        ],
        likes: 129,
        comments: 24,
        dateAssigned: DateTime(2025, 02, 14)),
    Workout(
      mainTitle: "2021 CrossFit Games Open",
      group: "Advanced",
      wodTitle: "OPEN 21.1",
      wodType: "For Time",
      wodTime: "20 minutes",
      movements: [
        Movement(reps: 1, name: "Wall Walks", weight: "Bodyweight"),
        Movement(reps: 10, name: "Double Unders", weight: "Rope"),
      ],
      likes: 89,
      comments: 12,
      dateAssigned: DateTime(2025, 02, 15),
    ),
    Workout(
      mainTitle: "2013 CrossFit Games Open",
      group: "Intermediate",
      wodTitle: "OPEN 13.2",
      wodType: "AMRAP",
      wodTime: "10 minutes",
      movements: [
        Movement(reps: 5, name: "Shoulder-to-Overheads", weight: "115/75 lb"),
        Movement(reps: 10, name: "Deadlifts", weight: "115/75 lb"),
        Movement(reps: 15, name: "Box Jumps", weight: "24/20 in"),
      ],
      likes: 129,
      comments: 24,
      dateAssigned: DateTime(2025, 02, 16),
    ),
    Workout(
      mainTitle: "2021 CrossFit Games Open",
      group: "Beginner",
      wodTitle: "OPEN 21.1",
      wodType: "For Time",
      wodTime: "20 minutes",
      movements: [
        Movement(reps: 1, name: "Wall Walks", weight: "Bodyweight"),
        Movement(reps: 10, name: "Double Unders", weight: "Rope"),
      ],
      likes: 89,
      comments: 12,
      dateAssigned: DateTime(2025, 02, 17),
    ),
    Workout(
      mainTitle: "2013 CrossFit Games Open",
      group: "Intermediate",
      wodTitle: "OPEN 13.2",
      wodType: "AMRAP",
      wodTime: "10 minutes",
      movements: [
        Movement(reps: 5, name: "Shoulder-to-Overheads", weight: "115/75 lb"),
        Movement(reps: 10, name: "Deadlifts", weight: "115/75 lb"),
        Movement(reps: 15, name: "Box Jumps", weight: "24/20 in"),
      ],
      likes: 129,
      comments: 24,
      dateAssigned: DateTime(2025, 02, 18),
    ),
    Workout(
      mainTitle: "2021 CrossFit Games Open",
      group: "Beginner",
      wodTitle: "OPEN 21.1",
      wodType: "For Time",
      wodTime: "20 minutes",
      movements: [
        Movement(reps: 1, name: "Wall Walks", weight: "Bodyweight"),
        Movement(reps: 10, name: "Double Unders", weight: "Rope"),
      ],
      likes: 89,
      comments: 12,
      dateAssigned: DateTime(2025, 02, 19),
    ),
    Workout(
      mainTitle: "2013 CrossFit Games Open",
      group: "Advanced",
      wodTitle: "OPEN 13.2",
      wodType: "AMRAP",
      wodTime: "10 minutes",
      movements: [
        Movement(reps: 5, name: "Shoulder-to-Overheads", weight: "115/75 lb"),
        Movement(reps: 10, name: "Deadlifts", weight: "115/75 lb"),
        Movement(reps: 15, name: "Box Jumps", weight: "24/20 in"),
      ],
      likes: 129,
      comments: 24,
      dateAssigned: DateTime(2025, 02, 20),
    ),
    Workout(
      mainTitle: "2021 CrossFit Games Open",
      group: "Advanced",
      wodTitle: "OPEN 21.1",
      wodType: "For Time",
      wodTime: "20 minutes",
      movements: [
        Movement(reps: 1, name: "Wall Walks", weight: "Bodyweight"),
        Movement(reps: 10, name: "Double Unders", weight: "Rope"),
      ],
      likes: 89,
      comments: 12,
      dateAssigned: DateTime(2025, 02, 21),
    ),
  ];

  List<Workout> get workouts => _workouts;

  void toggleMarkAsDone(int index) {
    _workouts[index] = Workout(
        mainTitle: _workouts[index].mainTitle,
        group: _workouts[index].group,
        wodTitle: _workouts[index].wodTitle,
        wodType: _workouts[index].wodType,
        wodTime: _workouts[index].wodTime,
        movements: _workouts[index].movements,
        likes: _workouts[index].likes,
        comments: _workouts[index].comments,
        isMarkedAsDone: !_workouts[index].isMarkedAsDone,
        dateAssigned: _workouts[index].dateAssigned);
    notifyListeners();
  }
}
