import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:fitsanny/model/training.dart';
import 'package:fitsanny/pages/training/training_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateTrainingPage extends StatelessWidget {
  final Training training;

  const UpdateTrainingPage({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Training')),
      body: BlocProvider.value(
        value: context.read<TrainingBloc>(),
        child: Builder(
          builder: (context) {
            // Initialize the bloc with the training to be edited
            // We need to do this in a microtask or post-frame callback to avoid
            // modifying state during build, or better yet, use a separate event
            // to set the "editing" state.
            // However, TrainingForm expects NewTraining state.
            // Let's emit NewTraining with the existing training data.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<TrainingBloc>().add(
                NewTrainingEvent(training: training),
              );
            });

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: TrainingForm(),
            );
          },
        ),
      ),
    );
  }
}
