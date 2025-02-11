import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:frontend/home%20screen/home_screen.dart';
import 'dart:convert';
import '../models/person.dart'; // Import your Person model
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bodyFatController = TextEditingController();
  final TextEditingController _fitnessLevelController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _workoutDaysController = TextEditingController();
  final TextEditingController _preferredWorkoutTypeController =
      TextEditingController();
  final TextEditingController _availableEquipmentController =
      TextEditingController();
  final TextEditingController _activityLevelController =
      TextEditingController();
  final TextEditingController _healthConditionsController =
      TextEditingController();
  final TextEditingController _pastInjuriesController = TextEditingController();
  final TextEditingController _dietaryPreferenceController =
      TextEditingController();
  final TextEditingController _workoutExperienceController =
      TextEditingController();
  final TextEditingController _availableWorkoutTimesController =
      TextEditingController();
  final TextEditingController _motivationLevelController =
      TextEditingController();
  final TextEditingController _averageDailyStepsController =
      TextEditingController();
  final TextEditingController _workoutDurationController =
      TextEditingController();
  final TextEditingController _stressLevelController = TextEditingController();
  final TextEditingController _sleepQualityController = TextEditingController();

  int _currentPage = 0;

  // List of controllers for easy iteration
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = [
      _nameController,
      _ageController,
      _genderController,
      _heightController,
      _weightController,
      _bodyFatController,
      _fitnessLevelController,
      _goalController,
      _workoutDaysController,
      _preferredWorkoutTypeController,
      _availableEquipmentController,
      _activityLevelController,
      _healthConditionsController,
      _pastInjuriesController,
      _dietaryPreferenceController,
      _workoutExperienceController,
      _availableWorkoutTimesController,
      _motivationLevelController,
      _averageDailyStepsController,
      _workoutDurationController,
      _stressLevelController,
      _sleepQualityController,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: _buildPages(),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                int adjustedIndex = (_currentPage / (22 / 5)).floor();
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        adjustedIndex == index ? Colors.white : Colors.white54,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: _currentPage == 21
          ? FloatingActionButton(
              onPressed: _submitData,
              child: Icon(Icons.check),
            )
          : null,
    );
  }

  List<Widget> _buildPages() {
    return [
      _buildPage('assets/images/image1.jpg', 'Enter your name', _nameController,
          'Your full name.'),
      _buildPage('assets/images/image2.jpg', 'Enter your age', _ageController,
          'Your age in years.',
          isNumeric: true),
      _buildPage('assets/images/image3.jpg', 'Enter your gender',
          _genderController, 'Male, Female, Non-binary, etc.'),
      _buildPage('assets/images/image4.jpg', 'Enter your height (cm)',
          _heightController, 'Height in centimeters.',
          isNumeric: true),
      _buildPage('assets/images/image5.jpg', 'Enter your weight (kg)',
          _weightController, 'Weight in kilograms.',
          isNumeric: true),
      _buildPage('assets/images/image6.jpg', 'Enter your body fat % (optional)',
          _bodyFatController, 'Body fat percentage if known.',
          isNumeric: true),
      _buildPage('assets/images/image7.jpg', 'Enter your fitness level',
          _fitnessLevelController, 'Beginner, Intermediate, Advanced'),
      _buildPage('assets/images/image8.jpg', 'Enter your goal', _goalController,
          'Weight Loss, Muscle Gain, etc.'),
      _buildPage('assets/images/image9.jpg', 'Workout Days per Week',
          _workoutDaysController, 'How many days you can train.',
          isNumeric: true),
      _buildPage('assets/images/image10.jpg', 'Preferred Workout Type',
          _preferredWorkoutTypeController, 'Cardio, Strength, Yoga, etc.'),
      _buildPage('assets/images/image11.jpg', 'Available Equipment',
          _availableEquipmentController, 'Dumbbells, Resistance Bands, etc.'),
      _buildPage('assets/images/image12.jpg', 'Enter your activity level',
          _activityLevelController, 'Sedentary, Active, Very Active'),
      _buildPage(
          'assets/images/image13.jpg',
          'Enter any health conditions',
          _healthConditionsController,
          'Any relevant health conditions (optional).'),
      _buildPage('assets/images/image14.jpg', 'Enter any past injuries',
          _pastInjuriesController, 'Any previous injuries (optional).'),
      _buildPage('assets/images/image15.jpg', 'Enter your dietary preferences',
          _dietaryPreferenceController, 'Vegetarian, Vegan, etc.'),
      _buildPage('assets/images/image16.jpg', 'Enter your workout experience',
          _workoutExperienceController, 'Beginner, Intermediate, Advanced'),
      _buildPage(
          'assets/images/image17.jpg',
          'Enter your available workout times',
          _availableWorkoutTimesController,
          'When can you work out?'),
      _buildPage('assets/images/image18.jpg', 'Enter your motivation level',
          _motivationLevelController, 'How motivated are you?'),
      _buildPage('assets/images/image19.jpg', 'Enter your average daily steps',
          _averageDailyStepsController, 'Steps per day on average.'),
      _buildPage('assets/images/image20.jpg', 'Enter your workout duration',
          _workoutDurationController, 'Duration in minutes per session.'),
      _buildPage('assets/images/image21.jpg', 'Enter your stress level',
          _stressLevelController, 'Low, Moderate, High'),
      _buildPage('assets/images/image22.jpg', 'Enter your sleep quality',
          _sleepQualityController, 'Good, Fair, Poor'),
    ];
  }

  Widget _buildPage(String imagePath, String hintText,
      TextEditingController controller, String tooltip,
      {bool isNumeric = false}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            style: TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.black45,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(tooltip)),
                  );
                },
                child: Icon(Icons.help_outline, color: Colors.white70),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId == null) {
      print('Error: User ID not found');
      return;
    }

    int? safeParseInt(String text) {
      return text.isNotEmpty ? int.tryParse(text) : null;
    }

    Person person = Person(
      userId: userId,
      name: _nameController.text,
      age: safeParseInt(_ageController.text) ?? 0, // Default to 0 if empty
      gender: _genderController.text,
      height: double.tryParse(_heightController.text) ?? 0.0, // Default to 0.0
      weight: double.tryParse(_weightController.text) ?? 0.0,
      bodyFatPercentage: _bodyFatController.text.isNotEmpty
          ? double.tryParse(_bodyFatController.text)
          : null, // Nullable
      fitnessLevel: _fitnessLevelController.text,
      goal: _goalController.text,
      workoutDaysPerWeek: safeParseInt(_workoutDaysController.text) ?? 0,
      preferredWorkoutType: _preferredWorkoutTypeController.text,
      availableEquipment: _availableEquipmentController.text
          .split(',')
          .map((e) => e.trim())
          .join(', '),
      activityLevel: _activityLevelController.text,
      healthConditions: _healthConditionsController.text
          .split(',')
          .map((e) => e.trim())
          .join(', '),
      pastInjuries: _pastInjuriesController.text
        ..split(',').map((e) => e.trim()).join(', '),
      dietaryPreference: _dietaryPreferenceController.text,
      workoutExperience: _workoutExperienceController.text
          .split(',')
          .map((e) => e.trim())
          .join(', '),
      availableWorkoutTimes: _availableWorkoutTimesController.text
          .split(',')
          .map((e) => e.trim())
          .join(', '),
      motivationLevel: _motivationLevelController.text,
      averageDailySteps: safeParseInt(_averageDailyStepsController.text) ?? 0,
      workoutDurationMinutes:
          safeParseInt(_workoutDurationController.text) ?? 0,
      stressLevel: _stressLevelController.text,
      sleepQuality: _sleepQualityController.text,
    );

    final url = Uri.parse('https://10.0.2.2:7215/api/Auth/savePreferences');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(person.toJson()),
      );

      if (response.statusCode == 200) {
        print('Data submitted successfully');
        await prefs.setString('userPreferences', json.encode(person.toJson()));

        // Navigate to DashboardScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('Failed to submit data: ${response.body}');
      }
    } catch (error) {
      print('Error submitting data: $error');
    }
  }
}
