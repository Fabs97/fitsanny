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
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a new Training'),
          content: TrainingForm(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => print('save'),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
