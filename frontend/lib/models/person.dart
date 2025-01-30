class Person {
  String name;
  int age;
  String fitnessLevel;
  int workoutDaysPerWeek;
  //height
  //weight
  //bodyFat
  //target(lose weight, gain muscle, increase power)
  //....

  Person({
    required this.name,
    required this.age,
    required this.fitnessLevel,
    required this.workoutDaysPerWeek,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'fitnessLevel': fitnessLevel,
      'workoutDaysPerWeek': workoutDaysPerWeek,
    };
  }
}
