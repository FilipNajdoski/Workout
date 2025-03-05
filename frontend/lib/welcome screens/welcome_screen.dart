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

  final List<Map<String, dynamic>> _fields = [
    {
      'key': 'name',
      'hint': 'Enter your name*',
      'tooltip': 'Your full name.',
      'isNumeric': false,
      'isRequired': true,
    },
    {
      'key': 'age',
      'hint': 'Enter your age*',
      'tooltip': 'Your age in years.',
      'isNumeric': true,
      'isRequired': true,
    },
    {
      'key': 'gender',
      'hint': 'Enter your gender*',
      'tooltip': 'Male, Female',
      'isNumeric': false,
      'dropdownEnums': ['Male', 'Female'],
      'isRequired': true,
    },
    {
      'key': 'height',
      'hint': 'Enter your height (cm)*',
      'tooltip': 'Height in centimeters.',
      'isNumeric': true,
      'isRequired': true,
    },
    {
      'key': 'weight',
      'hint': 'Enter your weight (kg)*',
      'tooltip': 'Weight in kilograms.',
      'isNumeric': true,
      'isRequired': true,
    },
    {
      'key': 'workoutExperience',
      'hint': 'Select your workout experience*',
      'tooltip': 'Yeards of experience.',
      'isNumeric': false,
      'isRequired': true,
    },
    {
      'key': 'fitnessLevel',
      'hint': 'Enter your fitness level*',
      'tooltip': 'Beginner, Intermediate, Advanced',
      'isNumeric': false,
      'dropdownEnums': ['Beginner', 'Intermediate', 'Advanced'],
      'isRequired': true,
    },
    {
      'key': 'workoutDays',
      'hint': 'Workout Days per Week*',
      'tooltip': 'How many days you can train.',
      'isNumeric': true,
      'dropdownEnums': ['1', '2', '3', '4', '5', '6', '7'],
      'isRequired': true,
    },
    {
      'key': 'availableWorkoutTimes',
      'hint': 'Enter your availability*',
      'tooltip': 'When can you work out?',
      'isNumeric': false,
      'dropdownEnums': ['Morning', 'Afternoon', 'Evening'],
      'isRequired': true,
    },
    {
      'key': 'bodyFat',
      'hint': 'Enter your body fat %',
      'tooltip': 'Body fat percentage if known.',
      'isNumeric': true,
      'isRequired': false,
    },
    {
      'key': 'goal',
      'hint': 'Enter your goal',
      'tooltip': 'Weight Loss, Muscle Gain, etc.',
      'isNumeric': false,
      'isRequired': false,
    },
    {
      'key': 'preferredWorkoutType',
      'hint': 'Preferred Workout Type',
      'tooltip': 'Preferred workout type.',
      'isNumeric': false,
      'dropdownEnums': ['EMOM', 'AMRAP', 'For Time', 'Tabata', 'Interval'],
      'isRequired': false,
    },
    {
      'key': 'availableEquipment',
      'hint': 'Favourite Equipment',
      'tooltip': 'Dumbbells, Resistance Bands, etc.',
      'isNumeric': false,
      'isRequired': false,
    },
    {
      'key': 'activityLevel',
      'hint': 'Enter your activity level',
      'tooltip': 'Sedentary, Active, Very Active',
      'isNumeric': false,
      'dropdownEnums': ['Sedentary', 'Active', 'Very Active'],
      'isRequired': false,
    },
    {
      'key': 'healthConditions',
      'hint': 'Enter any health conditions',
      'tooltip': 'Any relevant health conditions.',
      'isNumeric': false,
      'isRequired': false,
    },
    {
      'key': 'pastInjuries',
      'hint': 'Enter any past injuries',
      'tooltip': 'Any previous injuries.',
      'isNumeric': false,
      'isRequired': false,
    },
    {
      'key': 'dietaryPreference',
      'hint': 'Enter your dietary preferences',
      'tooltip': 'Vegetarian, Vegan, etc.',
      'isNumeric': false,
      'isRequired': false,
    },
    {
      'key': 'motivationLevel',
      'hint': 'Enter your motivation level',
      'tooltip': 'How motivated are you?',
      'isNumeric': false,
      'isRequired': false,
    },
    {
      'key': 'averageDailySteps',
      'hint': 'Enter your average daily steps',
      'tooltip': 'Steps per day on average.',
      'isNumeric': true,
      'isRequired': false,
    },
    {
      'key': 'workoutDuration',
      'hint': 'Enter your workout duration',
      'tooltip': 'Duration in minutes per session.',
      'isNumeric': true,
      'isRequired': false,
    },
    {
      'key': 'stressLevel',
      'hint': 'Enter your stress level',
      'tooltip': 'Low, Moderate, High',
      'isNumeric': false,
      'dropdownEnums': ['Low', 'Moderate', 'High'],
      'isRequired': false,
    },
    {
      'key': 'sleepQuality',
      'hint': 'Enter your sleep quality',
      'tooltip': 'Good, Fair, Poor',
      'isNumeric': false,
      'dropdownEnums': ['Good', 'Fair', 'Poor'],
      'isRequired': false,
    },
  ];
  late final List<List<Map<String, dynamic>>> _fieldGroups = [
    [
      _fields[0],
      _fields[1],
      _fields[2],
      _fields[3],
      _fields[4],
      _fields[6],
    ],
    [
      _fields[5],
      _fields[7],
      _fields[8],
      _fields[9],
      _fields[10],
      _fields[11],
    ],
    [
      _fields[12],
      _fields[13],
      _fields[14],
      _fields[15],
      _fields[16],
    ],
    [
      _fields[17],
      _fields[18],
      _fields[19],
      _fields[20],
      _fields[21],
    ],
  ];

  // Background images for each page.
  final List<String> _backgroundImages = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
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
      // retrieve the field definition based on key:
      final fieldDef = _fields.firstWhere((f) => f['key'] == key);
      final bool isRequired = fieldDef['isRequired'] ?? true;

      if (isRequired && value.isEmpty) {
        _errors[key] = "This field is required.";
        return;
      } else if (!isRequired && value.isEmpty) {
        _errors[key] = null;
        return;
      }

      // Additional validations if value is provided:
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
    });
  }

  // Validate all fields (across groups) and return true if all valid.
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

  // If validation fails, jump to the first group page with an error.
  void _jumpToFirstErrorPage() {
    for (int groupIndex = 0; groupIndex < _fieldGroups.length; groupIndex++) {
      for (var field in _fieldGroups[groupIndex]) {
        if (_errors[field['key']] != null) {
          _pageController.animateToPage(
            groupIndex,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return;
        }
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

  // Build a widget for a single field input (without an icon).
  Widget _buildFieldInput(Map<String, dynamic> field) {
    Widget inputWidget;
    if (field.containsKey('dropdownEnums')) {
      inputWidget = DropdownButtonFormField<String>(
        value: _controllers[field['key']]!.text.isEmpty
            ? null
            : _controllers[field['key']]!.text,
        hint: Text(
          field['hint'],
          style: TextStyle(color: Colors.white70),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black45,
          errorText: _errors[field['key']],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(field['tooltip'])),
              );
            },
            child: Icon(Icons.help_outline, color: Colors.white70),
          ),
        ),
        items: (field['dropdownEnums'] as List<String>)
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (String? newValue) {
          setState(() {
            _controllers[field['key']]!.text = newValue ?? '';
            _validateField(field['key']);
          });
        },
      );
    } else {
      inputWidget = TextField(
        controller: _controllers[field['key']],
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(field['tooltip'])),
              );
            },
            child: Icon(Icons.help_outline, color: Colors.white70),
          ),
        ),
        style: TextStyle(color: Colors.white, fontSize: 18),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: inputWidget,
    );
  }

  // Build a page that groups several field inputs with a background image.
  Widget _buildGroupPage(
      List<Map<String, dynamic>> group, String backgroundImage) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: group.map((field) => _buildFieldInput(field)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _fieldGroups.length,
        itemBuilder: (context, index) {
          return _buildGroupPage(_fieldGroups[index], _backgroundImages[index]);
        },
      ),
      floatingActionButton: _currentPage == _fieldGroups.length - 1
          ? FloatingActionButton(
              onPressed: _submitData,
              child: Icon(Icons.check),
            )
          : null,
    );
  }
}
