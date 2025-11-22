import 'package:fitsanny/bloc/exercise_name/exercise_name_bloc.dart';
import 'package:fitsanny/bloc/goal/goal_bloc.dart';
import 'package:fitsanny/bloc/goal/goal_event.dart';
import 'package:fitsanny/bloc/goal/goal_state.dart';
import 'package:fitsanny/components/form_stepper.dart';
import 'package:fitsanny/model/goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GoalBloc>().add(LoadGoals());
    context.read<ExerciseNameBloc>().add(LoadExerciseNamesEvent());
  }

  void _showGoalForm(BuildContext context, [Goal? goal]) {
    final formKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(goal == null ? 'Add Goal' : 'Edit Goal'),
          content: FormBuilder(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<ExerciseNameBloc, ExerciseNamesState>(
                  builder: (context, state) {
                    if (state is ExerciseNamesLoaded) {
                      return FormBuilderDropdown<int>(
                        name: 'exercise_id',
                        initialValue: goal?.exerciseId,
                        decoration: InputDecoration(labelText: 'Exercise'),
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
                  label: 'Target Reps',
                  initialValue: goal?.reps.toDouble() ?? 10,
                  step: 1,
                  isInteger: true,
                ),
                SizedBox(height: 16),
                FormStepper(
                  name: 'kgs',
                  label: 'Target Kgs',
                  initialValue: goal?.kgs ?? 20.0,
                  step: 0.5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
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
                    context.read<GoalBloc>().add(AddGoal(newGoal));
                  } else {
                    context.read<GoalBloc>().add(UpdateGoal(newGoal));
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Goals')),
      body: BlocBuilder<GoalBloc, GoalState>(
        builder: (context, state) {
          if (state is GoalsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GoalsLoaded) {
            if (state.goals.isEmpty) {
              return Center(child: Text('No goals set yet.'));
            }
            return ListView.builder(
              itemCount: state.goals.length,
              itemBuilder: (context, index) {
                final goal = state.goals[index];
                final exerciseNameState = context
                    .read<ExerciseNameBloc>()
                    .state;
                String exerciseName = 'Unknown Exercise';

                if (exerciseNameState is ExerciseNamesLoaded) {
                  final exercise = exerciseNameState.exerciseNames.firstWhere(
                    (e) => e.id == goal.exerciseId,
                    orElse: () =>
                        // Return a dummy object or handle gracefully
                        // For now, just let the name be 'Unknown'
                        // This relies on the fact that we can't easily create a dummy ExerciseName here
                        // without importing the model.
                        // Better approach:
                        throw Exception('Exercise not found'),
                  );
                  exerciseName = exercise.name;
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
                          context.read<GoalBloc>().add(DeleteGoal(goal.id!));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGoalForm(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
