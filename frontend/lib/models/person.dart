class Person {
  final int userId;
  final String name;
  final int age;
  final String gender;
  final double height; // in cm
  final double weight; // in kg
  final double? bodyFatPercentage; // Optional, for better fat/muscle tracking
  final String fitnessLevel; // Beginner, Intermediate, Advanced
  final String goal; // Weight Loss, Muscle Gain, Endurance, General Fitness
  final int workoutDaysPerWeek; // 1-7
  final String preferredWorkoutType; // Cardio, Strength, HIIT, Yoga, Mixed
  final String availableEquipment; // e.g., ["Dumbbells", "Barbell"]
  final String activityLevel; // Sedentary, Lightly Active, Active, Very Active
  final String healthConditions; // e.g., ["Knee Pain", "Back Issues"]
  final String? pastInjuries; // e.g., ["Ankle Sprain", "Shoulder Dislocation"]
  final String? dietaryPreference; // Vegan, Vegetarian, Standard, Keto, etc.
  final String? workoutExperience; // e.g., ["Weightlifting", "Running"]
  final String availableWorkoutTimes; // ["Morning", "Evening"]
  final String motivationLevel; // Low, Moderate, High
  final int averageDailySteps; // Step count for activity tracking
  final int workoutDurationMinutes; // Preferred workout duration
  final String? stressLevel; // Low, Moderate, High
  final String? sleepQuality; // Poor, Average, Good

  Person({
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.bodyFatPercentage,
    required this.fitnessLevel,
    required this.goal,
    required this.workoutDaysPerWeek,
    required this.preferredWorkoutType,
    required this.availableEquipment,
    required this.activityLevel,
    required this.healthConditions,
    this.pastInjuries,
    this.dietaryPreference,
    this.workoutExperience,
    required this.availableWorkoutTimes,
    required this.motivationLevel,
    required this.averageDailySteps,
    required this.workoutDurationMinutes,
    this.stressLevel,
    this.sleepQuality,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "age": age,
      "gender": gender,
      "height": height,
      "weight": weight,
      "bodyFatPercentage": bodyFatPercentage,
      "fitnessLevel": fitnessLevel,
      "goal": goal,
      "workoutDaysPerWeek": workoutDaysPerWeek,
      "preferredWorkoutType": preferredWorkoutType,
      "availableEquipment": availableEquipment,
      "activityLevel": activityLevel,
      "healthConditions": healthConditions,
      "pastInjuries": pastInjuries,
      "dietaryPreference": dietaryPreference,
      "workoutExperience": workoutExperience,
      "availableWorkoutTimes": availableWorkoutTimes,
      "motivationLevel": motivationLevel,
      "averageDailySteps": averageDailySteps,
      "workoutDurationMinutes": workoutDurationMinutes,
      "stressLevel": stressLevel,
      "sleepQuality": sleepQuality,
    };
  }
}
