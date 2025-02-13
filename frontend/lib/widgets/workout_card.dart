import 'package:flutter/material.dart';
import 'package:frontend/models/workout.dart';

class WorkoutCard extends StatelessWidget {
  final Workout? workout;
  final VoidCallback? onMarkAsDone;

  const WorkoutCard({
    Key? key,
    this.workout,
    this.onMarkAsDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: workout!.imageUrl.isNotEmpty
                        ? NetworkImage(workout!.imageUrl) // Load from network
                        : AssetImage('assets/images/image1.jpg')
                            as ImageProvider, // Load from assets
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 255 * 0.5),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        workout!.mainTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 4,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${workout!.wodType} - ${workout!.wodTime}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...workout!.movements.map(
                        (movement) => Text(
                          "${movement.reps} ${movement.name} (${movement.weight})",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(workout!.likes.toString()),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.comment, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(workout!.comments.toString()),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    workout!.isMarkedAsDone
                        ? Icons.check_box_outlined
                        : Icons.check_box_rounded,
                    color: workout!.isMarkedAsDone ? Colors.grey : Colors.blue,
                  ),
                  onPressed: onMarkAsDone,
                ),
                const Icon(Icons.share, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
