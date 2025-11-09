import 'package:fitsanny/bloc/exercise_name/exercise_name_bloc.dart';
import 'package:fitsanny/components/form_stepper.dart';
import 'package:fitsanny/model/training.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoggerDetails extends StatefulWidget {
  final Training training;
  const LoggerDetails({super.key, required this.training});

  @override
  State<LoggerDetails> createState() => _LoggerDetailsState();
}

class _LoggerDetailsState extends State<LoggerDetails> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: BlocBuilder<ExerciseNameBloc, ExerciseNamesState>(
              buildWhen: (previous, current) =>
                  previous != current && current is ExerciseNamesLoaded,
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8.0,
                  children: [
                    ...widget.training.exercises.asMap().map((idx, exercise) {
                      return MapEntry(
                        idx,
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              spacing: 16.0,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('test'),
                                Row(
                                  spacing: 8.0,
                                  children: [
                                    Expanded(
                                      child: FormStepper(
                                        name: 'kgs_$idx',
                                        label: 'kgs',
                                        step: 0.5,
                                        initialValue: exercise.kgs,
                                      ),
                                    ),
                                    Expanded(
                                      child: FormStepper(
                                        name: 'reps_$idx',
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
                        ),
                      );
                    }).values,
                  ],
                );
              },
            ),
          ),

          ElevatedButton(
            onPressed: () {
              print('saving performance');
            },
            child: Text('Save performance'),
          ),
        ],
      ),
    );
  }
}
