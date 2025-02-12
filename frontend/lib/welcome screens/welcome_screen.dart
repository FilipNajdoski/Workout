import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/home%20screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _errors = {};
  int _currentPage = 0;

  // List of field definitions with fixed image URLs and validation hints.
  final List<Map<String, dynamic>> _fields = [
    {
      'key': 'name',
      'hint': 'Enter your name',
      'tooltip': 'Your full name.',
      'image': 'assets/images/image1.jpg',
      'isNumeric': false
    },
    {
      'key': 'age',
      'hint': 'Enter your age',
      'tooltip': 'Your age in years.',
      'image': 'assets/images/image2.jpg',
      'isNumeric': true
    },
    {
      'key': 'gender',
      'hint': 'Enter your gender',
      'tooltip': 'Male, Female, Non-binary, etc.',
      'image': 'assets/images/image3.jpg',
      'isNumeric': false
    },
    {
      'key': 'height',
      'hint': 'Enter your height (cm)',
      'tooltip': 'Height in centimeters.',
      'image': 'assets/images/image4.jpg',
      'isNumeric': true
    },
    {
      'key': 'weight',
      'hint': 'Enter your weight (kg)',
      'tooltip': 'Weight in kilograms.',
      'image': 'assets/images/image5.jpg',
      'isNumeric': true
    },
    {
      'key': 'bodyFat',
      'hint': 'Enter your body fat % (optional)',
      'tooltip': 'Body fat percentage if known.',
      'image': 'assets/images/image6.jpg',
      'isNumeric': true
    },
    {
      'key': 'fitnessLevel',
      'hint': 'Enter your fitness level',
      'tooltip': 'Beginner, Intermediate, Advanced',
      'image': 'assets/images/image7.jpg',
      'isNumeric': false
    },
    {
      'key': 'goal',
      'hint': 'Enter your goal',
      'tooltip': 'Weight Loss, Muscle Gain, etc.',
      'image': 'assets/images/image8.jpg',
      'isNumeric': false
    },
    {
      'key': 'workoutDays',
      'hint': 'Workout Days per Week',
      'tooltip': 'How many days you can train.',
      'image': 'assets/images/image9.jpg',
      'isNumeric': true
    },
    {
      'key': 'preferredWorkoutType',
      'hint': 'Preferred Workout Type',
      'tooltip': 'Cardio, Strength, Yoga, etc.',
      'image': 'assets/images/image10.jpg',
      'isNumeric': false
    },
    {
      'key': 'availableEquipment',
      'hint': 'Available Equipment',
      'tooltip': 'Dumbbells, Resistance Bands, etc.',
      'image': 'assets/images/image11.jpg',
      'isNumeric': false
    },
    {
      'key': 'activityLevel',
      'hint': 'Enter your activity level',
      'tooltip': 'Sedentary, Active, Very Active',
      'image': 'assets/images/image12.jpg',
      'isNumeric': false
    },
    {
      'key': 'healthConditions',
      'hint': 'Enter any health conditions',
      'tooltip': 'Any relevant health conditions (optional).',
      'image': 'assets/images/image13.jpg',
      'isNumeric': false
    },
    {
      'key': 'pastInjuries',
      'hint': 'Enter any past injuries',
      'tooltip': 'Any previous injuries (optional).',
      'image': 'assets/images/image14.jpg',
      'isNumeric': false
    },
    {
      'key': 'dietaryPreference',
      'hint': 'Enter your dietary preferences',
      'tooltip': 'Vegetarian, Vegan, etc.',
      'image': 'assets/images/image15.jpg',
      'isNumeric': false
    },
    {
      'key': 'workoutExperience',
      'hint': 'Enter your workout experience',
      'tooltip': 'Beginner, Intermediate, Advanced',
      'image': 'assets/images/image16.jpg',
      'isNumeric': false
    },
    {
      'key': 'availableWorkoutTimes',
      'hint': 'Enter your available workout times',
      'tooltip': 'When can you work out?',
      'image': 'assets/images/image17.jpg',
      'isNumeric': false
    },
    {
      'key': 'motivationLevel',
      'hint': 'Enter your motivation level',
      'tooltip': 'How motivated are you?',
      'image': 'assets/images/image18.jpg',
      'isNumeric': false
    },
    {
      'key': 'averageDailySteps',
      'hint': 'Enter your average daily steps',
      'tooltip': 'Steps per day on average.',
      'image': 'assets/images/image19.jpg',
      'isNumeric': true
    },
    {
      'key': 'workoutDuration',
      'hint': 'Enter your workout duration',
      'tooltip': 'Duration in minutes per session.',
      'image': 'assets/images/image20.jpg',
      'isNumeric': true
    },
    {
      'key': 'stressLevel',
      'hint': 'Enter your stress level',
      'tooltip': 'Low, Moderate, High',
      'image': 'assets/images/image21.jpg',
      'isNumeric': false
    },
    {
      'key': 'sleepQuality',
      'hint': 'Enter your sleep quality',
      'tooltip': 'Good, Fair, Poor',
      'image': 'assets/images/image22.jpg',
      'isNumeric': false
    },
  ];

  @override
  void initState() {
    super.initState();
    // Create a controller and initialize an error entry for each field.
    for (var field in _fields) {
      _controllers[field['key']] = TextEditingController();
      _errors[field['key']] = null;
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _pageController.dispose();
    super.dispose();
  }

  // Helper functions for safe parsing.
  int? safeParseInt(String text) => int.tryParse(text);
  double? safeParseDouble(String text) => double.tryParse(text);

  // Validate a single field and update its error message.
  void _validateField(String key) {
    setState(() {
      final value = _controllers[key]!.text.trim();
      if (value.isEmpty) {
        _errors[key] = "This field is required.";
      } else {
        if (key == "name" && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          _errors[key] = "Only letters allowed";
        } else if ((key == "age" ||
                key == "workoutDays" ||
                key == "averageDailySteps" ||
                key == "workoutDuration") &&
            int.tryParse(value) == null) {
          _errors[key] = "Enter a valid number";
        } else if ((key == "height" || key == "weight" || key == "bodyFat") &&
            double.tryParse(value) == null) {
          _errors[key] = "Enter a valid decimal number";
        } else {
          _errors[key] = null;
        }
      }
    });
  }

  // Validate all fields (without changing pages) and return true if all valid.
  bool _validateAllFields() {
    bool allValid = true;
    for (var field in _fields) {
      String key = field['key'];
      _validateField(key);
      if (_errors[key] != null) {
        allValid = false;
      }
    }
    return allValid;
  }

  // If validation fails, jump to the first page with an error.
  void _jumpToFirstErrorPage() {
    for (int i = 0; i < _fields.length; i++) {
      if (_errors[_fields[i]['key']] != null) {
        _pageController.animateToPage(
          i,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      }
    }
  }

  // Submit the data. If validation fails, jump to the first error page.
  void _submitData() async {
    if (!_validateAllFields()) {
      _jumpToFirstErrorPage();
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId == null) {
      print('Error: User ID not found');
      return;
    }

    Person person = Person(
      userId: userId,
      name: _controllers["name"]!.text,
      age: safeParseInt(_controllers["age"]!.text) ?? 0,
      gender: _controllers["gender"]!.text,
      height: safeParseDouble(_controllers["height"]!.text) ?? 0.0,
      weight: safeParseDouble(_controllers["weight"]!.text) ?? 0.0,
      bodyFatPercentage: _controllers["bodyFat"]!.text.isNotEmpty
          ? safeParseDouble(_controllers["bodyFat"]!.text)
          : null,
      fitnessLevel: _controllers["fitnessLevel"]!.text,
      goal: _controllers["goal"]!.text,
      workoutDaysPerWeek: safeParseInt(_controllers["workoutDays"]!.text) ?? 0,
      preferredWorkoutType: _controllers["preferredWorkoutType"]!.text,
      availableEquipment: _controllers["availableEquipment"]!
          .text
          .split(',')
          .map((e) => e.trim())
          .join(', '),
      activityLevel: _controllers["activityLevel"]!.text,
      healthConditions: _controllers["healthConditions"]!
          .text
          .split(',')
          .map((e) => e.trim())
          .join(', '),
      pastInjuries: _controllers["pastInjuries"]!
          .text
          .split(',')
          .map((e) => e.trim())
          .join(', '),
      dietaryPreference: _controllers["dietaryPreference"]!.text,
      workoutExperience: _controllers["workoutExperience"]!
          .text
          .split(',')
          .map((e) => e.trim())
          .join(', '),
      availableWorkoutTimes: _controllers["availableWorkoutTimes"]!
          .text
          .split(',')
          .map((e) => e.trim())
          .join(', '),
      motivationLevel: _controllers["motivationLevel"]!.text,
      averageDailySteps:
          safeParseInt(_controllers["averageDailySteps"]!.text) ?? 0,
      workoutDurationMinutes:
          safeParseInt(_controllers["workoutDuration"]!.text) ?? 0,
      stressLevel: _controllers["stressLevel"]!.text,
      sleepQuality: _controllers["sleepQuality"]!.text,
    );

    final url = Uri.parse('https://10.0.2.2:7215/api/Auth/savePreferences');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(person.toJson()),
      );
      if (response.statusCode == 200) {
        await prefs.setString('userPreferences', json.encode(person.toJson()));
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

  // Build a single page for a field.
  Widget _buildPage(Map<String, dynamic> field) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(field['image']),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: _controllers[field['key']]!,
            keyboardType:
                field['isNumeric'] ? TextInputType.number : TextInputType.text,
            onChanged: (_) => _validateField(field['key']),
            decoration: InputDecoration(
              hintText: field['hint'],
              errorText: _errors[field['key']],
              filled: true,
              fillColor: Colors.black45,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(field['tooltip'])));
                },
                child: Icon(Icons.help_outline, color: Colors.white70),
              ),
            ),
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  // Build method: a PageView for all fields and a FAB (on the last page) to submit.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: _fields.map((field) => _buildPage(field)).toList(),
      ),
      floatingActionButton: _currentPage == _fields.length - 1
          ? FloatingActionButton(
              onPressed: _submitData,
              child: Icon(Icons.check),
            )
          : null,
    );
  }
}
