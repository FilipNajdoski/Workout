import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  bool _showMovementFields = false; // controls toggle
  List<dynamic> _movements = [];

  @override
  void initState() {
    super.initState();
    fetchMovements();
  }

  Future<void> fetchMovements() async {
    final String url = 'https://10.0.2.2:7215/api/Movement';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> movements = jsonDecode(response.body);
        setState(() {
          _movements = movements;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to load movements')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading movements')));
    }
  }

  Future<void> submitMovement() async {
    final String url = 'https://10.0.2.2:7215/api/Movement';
    int reps;
    try {
      reps = int.parse(_repsController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid input for reps')));
      return;
    }

    final body = jsonEncode({
      'reps': reps,
      'name': _nameController.text,
      'weight': _weightController.text,
    });

    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Movement saved successfully')));
        // clear input fields on success
        _repsController.clear();
        _nameController.clear();
        _weightController.clear();
        // Refresh the movement list after successful save
        fetchMovements();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save movement')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving movement')));
    }
  }

  @override
  void dispose() {
    _repsController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Widget _buildMovementList() {
    if (_movements.isEmpty) {
      return Text('No movements available.');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _movements.length,
      itemBuilder: (context, index) {
        final movement = _movements[index];
        return ListTile(
          title: Text(movement['name'] ?? 'No name'),
          subtitle:
              Text('Reps: ${movement['reps']} - Weight: ${movement['weight']}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Your existing logic for Workout button
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  child: Text('Workout', style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Toggle movement fields visibility
                  setState(() {
                    _showMovementFields = !_showMovementFields;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  child: Text('Movement', style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 20),
              if (_showMovementFields)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _repsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Reps',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: 'Weight',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: submitMovement,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 16.0),
                          child: Text('Save', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Display list of movements
                      _buildMovementList(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
