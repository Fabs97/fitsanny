import 'package:fitsanny/components/form_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fitsanny/l10n/app_localizations.dart';

class LoggerSetRow extends StatelessWidget {
  final int idx;
  final int exerciseId;
  final int reps;
  final double kgs;

  const LoggerSetRow({
    super.key,
    required this.idx,
    required this.exerciseId,
    required this.reps,
    required this.kgs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      spacing: 8.0,
      children: [
        Text(AppLocalizations.of(context)!.setLabel(idx + 1)),
        Expanded(
          child: FormStepper(
            name: 'kgs_${exerciseId}_$idx',
            label: AppLocalizations.of(context)!.kgsLabel,
            step: 0.5,
            initialValue: kgs,
          ),
        ),
        Expanded(
          child: FormStepper(
            name: 'reps_${exerciseId}_$idx',
            label: AppLocalizations.of(context)!.repsLabel,
            step: 1,
            initialValue: reps,
            isInteger: true,
          ),
        ),
      ],
    );
  }
}
