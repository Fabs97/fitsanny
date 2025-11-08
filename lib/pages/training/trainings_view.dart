import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TrainingsView extends StatelessWidget {
  const TrainingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (context, state) {
        return state.trainings.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('No trainings available, add one now!')),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TrainingBloc>().add(NewTrainingEvent());
                      context.go('/training/new');
                    },
                    child: Text('Add Training'),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    for (var training in state.trainings)
                      ListTile(
                        title: Text(training.title),
                        subtitle: Text(
                          'Exercises: ${training.exercises.length}',
                        ),
                      ),
                  ],
                ),
              );
      },
    );
  }
}
