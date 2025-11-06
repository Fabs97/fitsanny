import 'package:fitsanny/components/training_form.dart';
import 'package:flutter/material.dart';

class TrainingHome extends StatefulWidget {
  const TrainingHome({super.key});

  @override
  State<TrainingHome> createState() => _TrainingHomeState();
}

class _TrainingHomeState extends State<TrainingHome> {
  @override
  Widget build(BuildContext context) {
    return TrainingForm();
  }
}
