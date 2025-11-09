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
        return state is TrainingsLoaded && state.trainings.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('No trainings available, add one now!')),
                  _buildNewTrainingButton(context),
                ],
              )
            : state is TrainingsLoaded
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          for (var training in state.trainings)
                            Dismissible(
                              key: Key(training.id.toString()),
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  // deleted
                                  context.read<TrainingBloc>().add(
                                    RemoveTrainingEvent(training.id!),
                                  );
                                }
                              },
                              background: Container(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.delete,
                                      size: 32.0,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(training.title),
                                subtitle: Text(
                                  'Exercises: ${training.exercises.length}',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  _buildNewTrainingButton(context),
                ],
              )
            : Center(child: Text('Loading trainings...'));
      },
    );
  }

  _buildNewTrainingButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TrainingBloc>().add(NewTrainingEvent());
        context.go('/training/new');
      },
      child: Text('Add Training'),
    );
  }
}
