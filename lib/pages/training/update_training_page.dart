import 'package:fitsanny/bloc/training/training_cubit.dart';
import 'package:fitsanny/model/training.dart';
import 'package:fitsanny/pages/training/training_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateTrainingPage extends StatelessWidget {
  final Training training;

  const UpdateTrainingPage({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    // Initialize the bloc with the training to be edited
    // We use a microtask to avoid updating state during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainingCubit>().startNewTraining(training);
    });

    return TrainingForm();
  }
}
