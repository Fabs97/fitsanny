import 'package:fitsanny/bloc/exercise_name/exercise_name_cubit.dart';
import 'package:fitsanny/bloc/goal/goal_cubit.dart';
import 'package:fitsanny/bloc/goal/goal_state.dart';
import 'package:fitsanny/bloc/settings/settings_cubit.dart';
import 'package:fitsanny/bloc/settings/settings_state.dart';
import 'package:fitsanny/components/form_stepper.dart';
import 'package:fitsanny/model/goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fitsanny/l10n/app_localizations.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GoalCubit>().loadGoals();
    context.read<ExerciseNameCubit>().loadExerciseNames();
  }

  void _showGoalForm(BuildContext context, [Goal? goal]) {
    final formKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            goal == null
                ? AppLocalizations.of(context)!.addGoalTitle
                : AppLocalizations.of(context)!.editGoalTitle,
          ),
          content: FormBuilder(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<ExerciseNameCubit, ExerciseNamesState>(
                  builder: (context, state) {
                    if (state is ExerciseNamesLoaded) {
                      return FormBuilderDropdown<int>(
                        name: 'exercise_id',
                        initialValue: goal?.exerciseId,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.exerciseLabel,
                        ),
                        items: state.exerciseNames
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                SizedBox(height: 16),
                FormStepper(
                  name: 'reps',
                  label: AppLocalizations.of(context)!.targetRepsLabel,
                  initialValue: goal?.reps.toDouble() ?? 10,
                  step: 1,
                  isInteger: true,
                ),
                SizedBox(height: 16),
                FormStepper(
                  name: 'kgs',
                  label: AppLocalizations.of(context)!.targetKgsLabel,
                  initialValue: goal?.kgs ?? 20.0,
                  step: 0.5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.saveAndValidate() ?? false) {
                  final values = formKey.currentState!.value;
                  final newGoal = Goal(
                    id: goal?.id,
                    exerciseId: values['exercise_id'],
                    reps: (values['reps'] as num).toInt(),
                    kgs: (values['kgs'] as num).toDouble(),
                  );

                  if (goal == null) {
                    context.read<GoalCubit>().addGoal(newGoal);
                  } else {
                    context.read<GoalCubit>().updateGoal(newGoal);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return ListTile(
                  title: Text('Language'),
                  subtitle: Text(_getLanguageName(state.locale.languageCode)),
                  trailing: DropdownButton<String>(
                    value: state.locale.languageCode,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        context.read<SettingsCubit>().changeLanguage(
                          Locale(newValue),
                        );
                      }
                    },
                    items: [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                      DropdownMenuItem(value: 'it', child: Text('Italiano')),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Goals',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () => _showGoalForm(context),
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            BlocBuilder<GoalCubit, GoalState>(
              builder: (context, state) {
                if (state is GoalsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is GoalsLoaded) {
                  if (state.goals.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('No goals set yet.'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.goals.length,
                    itemBuilder: (context, index) {
                      final goal = state.goals[index];
                      final exerciseNameState = context
                          .read<ExerciseNameCubit>()
                          .state;
                      String exerciseName = 'Unknown Exercise';

                      if (exerciseNameState is ExerciseNamesLoaded) {
                        try {
                          final exercise = exerciseNameState.exerciseNames
                              .firstWhere((e) => e.id == goal.exerciseId);
                          exerciseName = exercise.name;
                        } catch (e) {
                          // Handle case where exercise is not found
                        }
                      }

                      return ListTile(
                        title: Text(exerciseName),
                        subtitle: Text('${goal.reps} reps @ ${goal.kgs} kg'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showGoalForm(context, goal),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                context.read<GoalCubit>().deleteGoal(goal.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is GoalError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      default:
        return 'Unknown';
    }
  }
}
