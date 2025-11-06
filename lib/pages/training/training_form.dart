import 'package:fitsanny/pages/training/exercise_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TrainingForm extends StatefulWidget {
  const TrainingForm({super.key});

  @override
  State<TrainingForm> createState() => _TrainingFormState();
}

class _TrainingFormState extends State<TrainingForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final List<Widget> _exerciseRows = [ExerciseRow()];

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        spacing: 10.0,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: _exerciseRows),
            ),
          ),
          Divider(),
          Row(
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => setState(() {
                  _exerciseRows.add(ExerciseRow());
                }),
                child: Text('Add Exercise'),
              ),
              ElevatedButton(onPressed: () {}, child: Text('Save')),
            ],
          ),
        ],
      ),
    );
  }
}
