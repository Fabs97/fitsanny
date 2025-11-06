import 'package:fitsanny/components/form_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ExerciseRow extends StatelessWidget {
  const ExerciseRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.max,
          children: [
            FormBuilderDropdown(
              name: 'Excercise',
              initialValue: 'Bulgarian split squats',
              items: ['Bulgarian split squats', 'Squats']
                  .map(
                    (exercise) => DropdownMenuItem(
                      value: exercise,
                      child: Text(exercise),
                    ),
                  )
                  .toList(),
            ),
            Row(
              spacing: 10.0,
              children: [
                Expanded(
                  child: FormStepper(
                    name: 'kgs',
                    label: 'kgs',
                    step: 0.5,
                    initialValue: 5,
                  ),
                ),
                Expanded(
                  child: FormStepper(
                    name: 'reps',
                    label: 'reps',
                    step: 1,
                    initialValue: 1,
                    isInteger: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
