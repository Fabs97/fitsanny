import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ExerciseForm extends StatefulWidget {
  const ExerciseForm({super.key});

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          FormBuilderTextField(
            name: 'exercise_name',
            decoration: InputDecoration(labelText: 'Exercise Name'),
          ),
          TextButton(
            onPressed: () {
              print("Saving exercise: ${_formKey.currentState?.fields}");
            },
            child: Text('Save Exercise'),
          ),
        ],
      ),
    );
  }
}
