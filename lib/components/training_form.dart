import 'package:fitsanny/components/form_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TrainingForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  TrainingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        spacing: 10.0,
        children: [
          FormBuilderDropdown(
            name: 'Excercise',
            initialValue: 'Bulgarian split squats',
            items: ['Bulgarian split squats', 'Squats']
                .map(
                  (exercise) =>
                      DropdownMenuItem(value: exercise, child: Text(exercise)),
                )
                .toList(),
          ),
          Row(
            spacing: 10.0,
            children: [
              Expanded(
                child: FormStepper(
                  name: 'kgs',
                  label: 'kgs',
                  step: 0.5,
                  initialValue: 5,
                ),
              ),
              Expanded(
                child: FormStepper(
                  name: 'reps',
                  label: 'reps',
                  step: 1,
                  initialValue: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
