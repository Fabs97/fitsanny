import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:fitsanny/pages/training/training_form.dart';
import 'package:fitsanny/pages/training/trainings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrainingHome extends StatefulWidget {
  const TrainingHome({super.key});

  @override
  State<TrainingHome> createState() => _TrainingHomeState();
}

class _TrainingHomeState extends State<TrainingHome> {
  @override
  Widget build(BuildContext context) {
    context.read<TrainingBloc>().add(LoadTrainingsEvent());
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (BuildContext context, TrainingState state) {
        if (state is TrainingsInitial || state is TrainingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TrainingsLoaded) {
          return TrainingsView();
        } else {
          return Center(
            child: Text(
              "TrainingHome::build - State RuntimeType: ${state.runtimeType}",
            ),
          );
        }
      },
    );
  }
}
