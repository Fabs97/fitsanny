import 'package:fitsanny/bloc/exercise_name/exercise_name_bloc.dart';
import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:fitsanny/pages/training/exercise_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TrainingForm extends StatefulWidget {
  const TrainingForm({super.key});

  @override
  State<TrainingForm> createState() => _TrainingFormState();
}

class _TrainingFormState extends State<TrainingForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    context.read<ExerciseNameBloc>().add(LoadExerciseNamesEvent());
    super.initState();
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
                    onPressed: () => setState(() {
                      state.addExercise();
                    }),
                    child: Text('Add Exercise'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(
                        "Saving training...: ${_formKey.currentState?.fields} exercises",
                      );
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
