import 'package:fitsanny/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fitsanny/pages/home/charts/chart_data.dart';
import 'package:fitsanny/model/goal.dart';

class GoalProgressChart extends StatelessWidget {
  final ChartData data;

  const GoalProgressChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isReps = data.goal.type == GoalType.reps;
    final current = isReps
        ? (data.latestSet?.reps.toDouble() ?? 0.0)
        : (data.latestSet?.kgs ?? 0.0);
    final target = isReps ? data.goal.reps.toDouble() : data.goal.kgs;
    final progress = (current / target).clamp(0.0, 1.0);

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
                Text(
                  isReps
                      ? '${AppLocalizations.of(context)!.reps(current.toInt())} / ${AppLocalizations.of(context)!.reps(target.toInt())}'
                      : AppLocalizations.of(context)!.goalCurrent(current),
                ),
                Text(
                  isReps
                      ? ''
                      : AppLocalizations.of(context)!.goalTarget(target),
                ),
              ],
            ),
            if (data.latestSet != null) ...[
              SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.reps(data.latestSet!.reps),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
