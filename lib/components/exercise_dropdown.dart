import 'package:fitsanny/bloc/exercise_name/exercise_name_bloc.dart';
import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:fitsanny/pages/training/exercise_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class ExerciseDropdown extends StatefulWidget {
  const ExerciseDropdown({
    super.key,
    required this.name,
    required this.exerciseIndex,
  });

  final String name;
  final int exerciseIndex;

  @override
  State<ExerciseDropdown> createState() => _ExerciseDropdownState();
}

class _ExerciseDropdownState extends State<ExerciseDropdown> {
  String? selectedValue;

  final FocusNode dropDownFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseNameBloc, ExerciseNamesState>(
      builder: (context, exerciseNameState) {
        if (exerciseNameState is ExerciseNamesError) {
          return Center(child: Text('Error: ${exerciseNameState.message}'));
        }
        return BlocBuilder<TrainingBloc, TrainingState>(
          builder: (context, trainingState) {
            if (trainingState is NewTraining) {
              final currentExercise =
                  trainingState.newTraining.exercises[widget.exerciseIndex];
              return FormBuilderDropdown<int>(
                name: widget.name,
                initialValue: currentExercise.exerciseNameId == 0
                    ? null
                    : currentExercise.exerciseNameId,
                hint: const Text('Choose an exercise'),
                items:
                    exerciseNameState is ExerciseNamesLoaded &&
                        exerciseNameState.exerciseNames.isNotEmpty
                    ? [
                        ...exerciseNameState.exerciseNames.map(
                          (exerciseName) => DropdownMenuItem<int>(
                            value: exerciseName.id,
                            child: Text(exerciseName.name),
                          ),
                        ),
                        _buildCreateNewItem(context),
                      ]
                    : exerciseNameState is ExerciseNamesLoaded &&
                          exerciseNameState.exerciseNames.isEmpty
                    ? [
                        DropdownMenuItem(
                          value: null,
                          child: Text('No exercises available'),
                        ),
                        _buildCreateNewItem(context),
                      ]
                    : [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Loading exercises...'),
                        ),
                      ],
                focusNode: dropDownFocus,
                isExpanded: true,
                onChanged: (int? value) {
                  if (value != null) {
                    // Dispatch an event to change the exercise selection in the NewTraining state
                    context.read<TrainingBloc>().add(
                      ChangeExerciseInNewTrainingEvent(
                        index: widget.exerciseIndex,
                        exerciseNameId: value,
                      ),
                    );
                  }
                },
              );
            } else {
              return Center(
                child: Text(
                  "ExerciseDropdown::build - Training State ${trainingState.runtimeType}",
                ),
              );
            }
          },
        );
      },
    );
  }

  DropdownMenuItem<int> _buildCreateNewItem(BuildContext context) {
    return DropdownMenuItem<int>(
      value: 0,
      child: TextButton(
        child: Text('Create'),
        onPressed: () {
          dropDownFocus.context!.pop();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Create new exercise'),
              content: ExerciseForm(),
            ),
          );
        },
      ),
    );
  }
}
