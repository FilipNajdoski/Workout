class Workout {
  final String mainTitle;
  final String group;
  final String wodTitle;
  final String wodType;
  final String wodTime;
  final List<Movement> movements;
  final int likes;
  final int comments;
  final bool isMarkedAsDone;
  final String imageUrl;
  final DateTime? dateAssigned;

  Workout(
      {required this.mainTitle,
      required this.group,
      required this.wodTitle,
      required this.wodType,
      required this.wodTime,
      required this.movements,
      required this.likes,
      required this.comments,
      this.isMarkedAsDone = false,
      this.imageUrl = "",
      this.dateAssigned});
}

class Movement {
  final int reps;
  final String name;
  final String weight;

  Movement({required this.reps, required this.name, required this.weight});
}
