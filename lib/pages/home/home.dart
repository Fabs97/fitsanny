import 'package:fitsanny/components/action_button.dart';
import 'package:fitsanny/components/expandable_fab.dart';
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
            onPressed: () => _showAction(context, ''),
            icon: Icons.format_size,
          ),
          ActionButton(
            onPressed: () => _showAction(context, 'Insert Photo'),
            icon: Icons.insert_photo,
          ),
          ActionButton(
            onPressed: () => _showAction(context, 'Videocam'),
            icon: Icons.videocam,
          ),
        ],
      ),
    );
  }

  void _showAction(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(title),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }
}
