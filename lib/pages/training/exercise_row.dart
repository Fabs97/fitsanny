import 'package:fitsanny/components/exercise_dropdown.dart';
import 'package:fitsanny/components/form_stepper.dart';
import 'package:fitsanny/model/exercise.dart';
import 'package:fitsanny/utils/uuid_utils.dart';
import 'package:flutter/material.dart';

class ExerciseRow extends StatelessWidget {
  @override
  Key? get key => ValueKey(UuidUtils.generate());

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
            ExerciseDropdown(
              name: 'exercise_$key',
              items: List.generate(
                5,
                (exercise) => Exercise(
                  id: exercise,
                  exerciseNameId: exercise,
                  reps: 0,
                  kgs: 0,
                ),
              ),
            ),
            Row(
              spacing: 10.0,
              children: [
                Expanded(
                  child: FormStepper(
                    name: 'kgs_$key',
                    label: 'kgs',
                    step: 0.5,
                    initialValue: 5,
                  ),
                ),
                Expanded(
                  child: FormStepper(
                    name: 'reps_$key',
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
