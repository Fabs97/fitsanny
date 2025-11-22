import 'package:collection/collection.dart';
import 'package:fitsanny/bloc/log/log_bloc.dart';
import 'package:fitsanny/l10n/app_localizations.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/model/set.dart';
import 'package:fitsanny/pages/logger/logger_bloc.dart';
import 'package:fitsanny/pages/logger/logger_set_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoggerDetails extends StatefulWidget {
  final Log? logToEdit;
  const LoggerDetails({super.key, this.logToEdit});

  @override
  State<LoggerDetails> createState() => _LoggerDetailsState();
}

class _LoggerDetailsState extends State<LoggerDetails> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late Log? log;

  @override
  void initState() {
    super.initState();
    LogState currentLogState = BlocProvider.of<LogBloc>(context).state;
    LoggerState currentLoggerState = BlocProvider.of<LoggerBloc>(context).state;

    if (widget.logToEdit != null) {
      log = widget.logToEdit;
      // We need to load the training for this log to display exercises correctly
      // But LoggerDetails assumes LoggerBloc has the training.
      // If we are coming from Home, LoggerBloc might not have the training set.
      // We should probably set the training in LoggerBloc or fetch it.
      // For now, let's assume we need to fetch the training or use what's in the log if we had training info.
      // But Log object only has trainingId.
      // We need to ensure LoggerBloc has the correct training loaded.
      // This is tricky because LoggerDetails relies on LoggerBloc state being ChosenTraining.
      // If we edit, we need to simulate that state.
      context.read<LoggerBloc>().add(
        LoadTraining(widget.logToEdit!.trainingId),
      );
    } else if (currentLogState is LogsLoaded) {
      final logs = currentLogState.logs;

      // Only create a log if training is selected
      if (currentLoggerState.training != null) {
        log = Log(
          trainingId: currentLoggerState.training!.id!,
          sets: logs.isEmpty
              // No logs available yet
              ? currentLoggerState.training!.exercises
                    .map(
                      (e) => Set(exerciseId: e.id!, reps: e.reps, kgs: e.kgs),
                    )
                    .toList()
              : logs.first.sets,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, List<Set>> setsGroupedByExerciseId = groupBy<Set, int>(
      log?.sets ?? [],
      (Set set) => set.exerciseId,
    );

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
                FormBuilderDateTimePicker(
                  name: 'date',
                  initialValue: log?.createdAt ?? DateTime.now(),
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.dateLabel,
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                if (loggerState is ChosenTraining)
                  Expanded(
                    child: ListView(
                      children: [
                        ...setsGroupedByExerciseId.entries.map((entry) {
                          final exerciseId = entry.key;
                          final sets = entry.value;
                          final exercise = loggerState.training!.exercises
                              .firstWhere((e) => e.id == exerciseId);

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise.exerciseName ?? 'Unknown',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  ...sets.asMap().entries.map((setEntry) {
                                    final setIndex = setEntry.key;
                                    final set = setEntry.value;
                                    return LoggerSetRow(
                                      idx: setIndex,
                                      exerciseId: exerciseId,
                                      reps: set.reps,
                                      kgs: set.kgs,
                                    );
                                  }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          int index = (log?.sets ?? [])
                                              .lastIndexWhere(
                                                (s) =>
                                                    s.exerciseId == exerciseId,
                                              );
                                          if (index >= 0) {
                                            setState(() {
                                              log?.sets.removeAt(index);
                                            });
                                          }
                                        },
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.removeSet,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            log = log?.copyWith(
                                              sets: [
                                                ...(log?.sets ?? []),
                                                Set.empty(
                                                  exerciseId: exerciseId,
                                                ),
                                              ],
                                            );
                                          });
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.addSet,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  )
                else
                  Center(
                    child: Text(
                      'LoggerDetails::build - LoggerState is wrong: ${loggerState.runtimeType}',
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton.filled(
                      icon: Icon(Icons.save, size: 32),
                      onPressed: () {
                        final temp = <String, Map<String, dynamic>>{};

                        for (final entry
                            in _formKey.currentState!.fields.entries) {
                          final match = RegExp(
                            r'^(kgs|reps)_(\d+)_(\d+)$',
                          ).firstMatch(entry.key);
                          if (match == null) continue;

                          final fieldType = match.group(1)!; // 'kgs' or 'reps'
                          final exerciseId = match.group(2)!;
                          final setIndex = match.group(3)!;

                          final key = '${exerciseId}_$setIndex';

                          temp.putIfAbsent(
                            key,
                            () => {
                              'exerciseId': int.parse(exerciseId),
                              'kgs': null,
                              'reps': null,
                            },
                          );

                          temp[key]![fieldType] = entry.value.value;
                        }

                        // Convert to Set objects
                        final sets = temp.values.map((m) {
                          return Set(
                            exerciseId: m['exerciseId'] as int,
                            kgs: (m['kgs'] ?? 0),
                            reps: (m['reps'] ?? 0),
                          );
                        }).toList();

                        if (log != null) {
                          final date =
                              _formKey.currentState?.fields['date']?.value;
                          final updatedLog = log!.copyWith(
                            sets: sets,
                            createdAt: date,
                          );

                          if (widget.logToEdit != null) {
                            context.read<LogBloc>().add(
                              UpdateLogEvent(
                                updatedLog,
                                onComplete: (success, {data}) {
                                  if (success) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            );
                          } else {
                            context.read<LogBloc>().add(
                              AddLogsEvent(
                                [updatedLog],
                                onComplete: (success, {data}) {
                                  if (success) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
