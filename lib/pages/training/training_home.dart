import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:fitsanny/pages/training/training_form.dart';
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
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (BuildContext context, TrainingState state) {
        if (state is TrainingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TrainingError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return TrainingForm();
      },
    );
  }
}
