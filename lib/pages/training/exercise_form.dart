import 'package:fitsanny/bloc/exercise_name/exercise_name_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<ExerciseNameBloc, ExerciseNamesState>(
      builder: (context, state) {
        if (state is! ExerciseNamesLoaded) {
          return Center(child: Text('Loading...'));
        }
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
                  final name =
                      _formKey.currentState?.fields['exercise_name']?.value ??
                      '';
                  if (name.isNotEmpty) {
                    context.read<ExerciseNameBloc>().add(
                      AddExerciseNameEvent(name),
                    );
                    Navigator.pop(
                      context,
                    ); // Bloc handles refresh automatically
                  }
                },
                child: Text('Save Exercise'),
              ),
            ],
          ),
        );
      },
    );
  }
}
