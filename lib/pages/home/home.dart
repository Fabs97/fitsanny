import 'package:fitsanny/components/action_button.dart';
import 'package:fitsanny/components/expandable_fab.dart';
import 'package:fitsanny/components/training_form.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SafeArea(
        child: Column(children: [Center(child: const Text('Hallo Sanny <3'))]),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => _showAction(context),
            icon: Icons.fitness_center,
          ),
        ],
      ),
    );
  }

  Future<void> _showAction(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
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
