import 'package:fitsanny/bloc/exercise_name/exercise_name_bloc.dart';
import 'package:fitsanny/pages/training/exercise_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ExerciseDropdown extends StatefulWidget {
  const ExerciseDropdown({super.key, required this.name});

  final String name;

  @override
  State<ExerciseDropdown> createState() => _ExerciseDropdownState();
}

class _ExerciseDropdownState extends State<ExerciseDropdown> {
  String? selectedValue;

  final FocusNode dropDownFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseNameBloc, ExerciseNamesState>(
      builder: (context, state) {
        if (state is ExerciseNamesError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return FormBuilderDropdown<String>(
          name: widget.name,
          items: state is ExerciseNamesLoaded && state.exerciseNames.isNotEmpty
              ? [
                  ...state.exerciseNames.map(
                    (exerciseName) => DropdownMenuItem<String>(
                      value: exerciseName.id.toString(),
                      child: Text(exerciseName.name),
                    ),
                  ),
                  _buildCreateNewItem(context),
                ]
              : state is ExerciseNamesLoaded && state.exerciseNames.isEmpty
              ? [
                  DropdownMenuItem(
                    value: null,
                    child: Text('No exercises available'),
                  ),
                  _buildCreateNewItem(context),
                ]
              : [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Loading exercises...'),
                  ),
                ],
          focusNode: dropDownFocus,
          isExpanded: true,
          onChanged: (String? value) {
            setState(() {
              selectedValue = value;
            });
          },
        );
      },
    );
  }

  DropdownMenuItem<String> _buildCreateNewItem(BuildContext context) {
    return DropdownMenuItem<String>(
      value: 'create',
      child: TextButton(
        child: Text('Create'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Create new exercise'),
              content: ExerciseForm(),
            ),
          );
        },
      ),
    );
  }
}
