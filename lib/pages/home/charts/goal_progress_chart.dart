import 'package:fitsanny/pages/home/charts/chart_data.dart';
import 'package:flutter/material.dart';

class GoalProgressChart extends StatelessWidget {
  final ChartData data;

  const GoalProgressChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currentKgs = data.latestSet?.kgs ?? 0.0;
    final goalKgs = data.goal.kgs;
    final progress = (currentKgs / goalKgs).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.exerciseName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current: ${currentKgs}kg'),
                Text('Goal: ${goalKgs}kg'),
              ],
            ),
            if (data.latestSet != null) ...[
              SizedBox(height: 4),
              Text(
                '${data.latestSet!.reps} reps',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
