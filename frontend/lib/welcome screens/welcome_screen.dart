import 'package:flutter/material.dart';
import '../models/person.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _fitnessLevelController = TextEditingController();
  final TextEditingController _workoutDaysController = TextEditingController();

  int _currentPage = 0;

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
            children: [
              _buildPage('assets/images/istockphoto-491268392-612x612.jpg',
                  'Enter your name', _nameController),
              _buildPage('assets/images/istockphoto-2154708948-640x640.jpg',
                  'Enter your age', _ageController,
                  isNumeric: true),
              _buildPage('assets/images/istockphoto-629265846-612x612.jpg',
                  'Fitness Level (e.g., Beginner)', _fitnessLevelController),
              _buildPage('assets/images/istockphoto-542197916-612x612.jpg',
                  'Workout Days per Week', _workoutDaysController,
                  isNumeric: true),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPage == index ? Colors.white : Colors.white54,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPage < 3) {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else {
            _submitData();
          }
        },
        child: Icon(_currentPage < 3 ? Icons.arrow_forward : Icons.check),
      ),
    );
  }

  Widget _buildPage(
      String imagePath, String hintText, TextEditingController controller,
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
            ),
          ),
        ),
      ),
    );
  }

  void _submitData() {
    final person = Person(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      fitnessLevel: _fitnessLevelController.text,
      workoutDaysPerWeek: int.tryParse(_workoutDaysController.text) ?? 0,
    );
    print(person.toJson());
  }
}
