import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:fitsanny/components/exercise_dropdown.dart';
import 'package:fitsanny/components/form_stepper.dart';
// uuid_utils no longer needed here
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseRow extends StatelessWidget {
  final int exerciseIndex;

  const ExerciseRow({super.key, required this.exerciseIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (context, state) {
        if (state is! NewTraining) {
          return Center(
            child: Text('Wrong current state ${state.runtimeType}'),
          );
        }
        final exercise = state.newTraining.exercises[exerciseIndex];
        return Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10.0,
              mainAxisSize: MainAxisSize.max,
              children: [
                ExerciseDropdown(
                  name: 'exercise_$exerciseIndex',
                  exerciseIndex: exerciseIndex,
                ),
                Row(
                  spacing: 10.0,
                  children: [
                    Expanded(
                      child: FormStepper(
                        name: 'kgs_$exerciseIndex',
                        label: 'kgs',
                        step: 0.5,
                        initialValue: exercise.kgs,
                      ),
                    ),
                    Expanded(
                      child: FormStepper(
                        name: 'reps_$exerciseIndex',
                        label: 'reps',
                        step: 1,
                        initialValue: exercise.reps,
                        isInteger: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
