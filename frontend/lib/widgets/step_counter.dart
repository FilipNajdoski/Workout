import 'package:flutter/material.dart';

class StepCounterWidget extends StatelessWidget {
  final int steps;
  final int maxSteps;
  final String title;

  const StepCounterWidget({
    Key? key,
    required this.steps,
    required this.maxSteps,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = (steps / maxSteps).clamp(0.0, 1.0); // Ensure between 0-1
    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 120,
          height: 120,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: Duration(seconds: 1),
            builder: (context, value, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 8,
                      backgroundColor:
                          Colors.grey[300], // Adjust background color
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.lightGreenAccent),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$steps",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      Text(
                        "/$maxSteps",
                        style: TextStyle(
                            fontSize: 14, color: textColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
