import 'package:fitsanny/bloc/exercise_name/exercise_name_bloc.dart';
import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:fitsanny/model/exercise.dart';
import 'package:fitsanny/pages/training/exercise_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:fitsanny/l10n/app_localizations.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addTraining)),
      body: BlocConsumer<TrainingBloc, TrainingState>(
        listener: (context, state) {
          if (state is TrainingsLoaded) {
            context.go('/training');
          } else if (state is TrainingsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is! NewTraining) {
            return Center(child: Text(AppLocalizations.of(context)!.loading));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'title',
                    initialValue: state.newTraining.title,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.titleLabel,
                    ),
                    onChanged: (value) {
                      context.read<TrainingBloc>().add(
                        NewTrainingEvent(
                          training: state.newTraining.copyWith(title: value),
                        ),
                      );
                    },
                    validator: FormBuilderValidators.required(),
                  ),
                  SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'description',
                    initialValue: state.newTraining.description,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.descriptionLabel,
                    ),
                    onChanged: (value) {
                      context.read<TrainingBloc>().add(
                        NewTrainingEvent(
                          training: state.newTraining.copyWith(
                            description: value,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.newTraining.exercises.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(child: ExerciseRow(exerciseIndex: index)),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                final updatedExercises = List<Exercise>.from(
                                  state.newTraining.exercises,
                                )..removeAt(index);
                                context.read<TrainingBloc>().add(
                                  NewTrainingEvent(
                                    training: state.newTraining.copyWith(
                                      exercises: updatedExercises,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TrainingBloc>().add(
                        AddExerciseToNewTrainingEvent(),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.addExercise),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final event = state.newTraining.id != null
                            ? UpdateTrainingEvent(state.newTraining)
                            : AddTrainingEvent(state.newTraining);
                        context.read<TrainingBloc>().add(event);
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.save),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
