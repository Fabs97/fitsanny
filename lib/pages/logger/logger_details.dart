import 'package:fitsanny/bloc/log/log_bloc.dart';
import 'package:fitsanny/components/form_stepper.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/pages/logger/logger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoggerDetails extends StatefulWidget {
  const LoggerDetails({super.key});

  @override
  State<LoggerDetails> createState() => _LoggerDetailsState();
}

class _LoggerDetailsState extends State<LoggerDetails> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late Log log;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: BlocBuilder<LoggerBloc, LoggerState>(
        builder: (context, loggerState) {
          return FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: BlocBuilder<LogBloc, LogState>(
                    builder: (context, state) {
                      if (state is LogsLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is! LogsLoaded) {
                        return Center(
                          child: Text(
                            'LoggerDetails::build - Wrong event type : ${state.runtimeType}',
                          ),
                        );
                      }
                      if (loggerState is ChosenTraining) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          spacing: 8.0,
                          children: [
                            ...loggerState.training!.exercises.asMap().map((
                              idx,
                              exercise,
                            ) {
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
                                        Text(exercise.exerciseName!),
                                        ...(state.logs.isEmpty
                                            // No logs available yet
                                            ? [
                                                _buildRow(
                                                  0,
                                                  exercise.reps,
                                                  exercise.kgs,
                                                ),
                                              ]
                                            // No logs are already
                                            : state.logs.first.sets
                                                  .asMap()
                                                  .map(
                                                    (idx, s) => MapEntry(
                                                      idx,
                                                      _buildRow(
                                                        idx,
                                                        s.reps,
                                                        s.kgs,
                                                      ),
                                                    ),
                                                  )
                                                  .values),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).values,
                          ],
                        );
                      } else {
                        return Center(
                          child: Text(
                            'LoggerDetails::build - LoggerState is wrong: ${loggerState.runtimeType}',
                          ),
                        );
                      }
                    },
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    // context.read<LogBloc>().add(
                    //   AddLogsEvent(
                    //     widget.training.exercises
                    //         .map(
                    //           (e) => Log(
                    //             trainingId: widget.training.id!,
                    //             exerciseId: e.id!,
                    //             kgs: e.kgs,
                    //             reps: e.reps,
                    //           ),
                    //         )
                    //         .toList(),
                    //   ),
                    // );
                  },
                  child: Text('Save performance'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(int idx, int reps, double kgs) {
    return Row(
      spacing: 8.0,
      children: [
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
