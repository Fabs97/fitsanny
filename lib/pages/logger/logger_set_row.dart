import 'package:fitsanny/components/form_stepper.dart';
import 'package:flutter/material.dart';

class LoggerSetRow extends StatelessWidget {
  final int idx;
  final int reps;
  final double kgs;
  const LoggerSetRow({
    super.key,
    required this.idx,
    required this.reps,
    required this.kgs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      spacing: 16.0,
      children: [
        Text('Set #${idx + 1}'),
        Expanded(
          child: FormStepper(
            name: 'kgs_$idx',
            label: 'kgs',
            step: 0.5,
            initialValue: kgs,
          ),
        ),
        Expanded(
          child: FormStepper(
            name: 'reps_$idx',
            label: 'reps',
            step: 1,
            initialValue: reps,
            isInteger: true,
          ),
        ),
      ],
    );
  }
}
