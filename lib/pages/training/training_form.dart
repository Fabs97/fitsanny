import 'package:fitsanny/bloc/exercise_name/exercise_name_bloc.dart';
import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:fitsanny/pages/training/exercise_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class TrainingForm extends StatefulWidget {
  const TrainingForm({super.key});

  @override
  State<TrainingForm> createState() => _TrainingFormState();
}

class _TrainingFormState extends State<TrainingForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    context.read<ExerciseNameBloc>().add(LoadExerciseNamesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (context, state) {
        if (state is! NewTraining) {
          return Center(child: Text('Loading...'));
        }
        return FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            spacing: 10.0,
            children: [
              FormBuilderTextField(
                name: 'title',
                initialValue: state.newTraining.title,
                onChanged: (value) => state.newTraining.copyWith(title: value),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  suffixIcon: Icon(Icons.edit),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                name: 'description',
                initialValue: state.newTraining.description,
                onChanged: (value) =>
                    state.newTraining.copyWith(description: value),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  suffixIcon: Icon(Icons.description),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 8.0,
                    children: state.newTraining.exercises
                        .asMap()
                        .map(
                          (idx, _) =>
                              MapEntry(idx, ExerciseRow(exerciseIndex: idx)),
                        )
                        .values
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
              ),
              Divider(),
              Row(
                spacing: 10.0,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<TrainingBloc>().add(
                        AddExerciseToNewTrainingEvent(),
                      );
                    },
                    child: Text('Add Exercise'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(state.newTraining);
                      // Extract updated exercises from form fields
                      final updatedExercises = state.newTraining.exercises
                          .asMap()
                          .entries
                          .map((e) {
                            final idx = e.key;
                            final exercise = e.value;
                            final reps = _formKey
                                .currentState
                                ?.fields['reps_$idx']
                                ?.value;
                            final kgs = _formKey
                                .currentState
                                ?.fields['kgs_$idx']
                                ?.value;

                            return exercise.copyWith(
                              reps: reps is String
                                  ? int.tryParse(reps) ?? exercise.reps
                                  : (reps as num?)?.toInt() ?? exercise.reps,
                              kgs: kgs is String
                                  ? double.tryParse(kgs) ?? exercise.kgs
                                  : (kgs as num?)?.toDouble() ?? exercise.kgs,
                            );
                          })
                          .toList();

                      final updatedTraining = state.newTraining.copyWith(
                        title:
                            _formKey.currentState?.fields['title']!.value ??
                            state.newTraining.title,
                        description:
                            _formKey.currentState?.fields['description']?.value,
                        exercises: updatedExercises,
                      );

                      final event = state.newTraining.id != null
                          ? UpdateTrainingEvent(
                              updatedTraining,
                              onComplete: (success) {
                                if (success && context.mounted) {
                                  context.go('/training');
                                }
                                if (!success) {
                                  // TODO: add snackbar
                                  print("Error updating a training");
                                }
                              },
                            )
                          : AddTrainingEvent(
                              updatedTraining,
                              onComplete: (success) {
                                if (success && context.mounted) {
                                  context.go('/training');
                                }
                                if (!success) {
                                  // TODO: add snackbar
                                  print("Error adding a training");
                                }
                              },
                            );

                      context.read<TrainingBloc>().add(event);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
