import 'package:fitsanny/model/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ExerciseDropdown extends StatefulWidget {
  const ExerciseDropdown({super.key, required this.name, required this.items});

  final String name;
  final List<Exercise> items;

  @override
  State<ExerciseDropdown> createState() => _ExerciseDropdownState();
}

class _ExerciseDropdownState extends State<ExerciseDropdown> {
  String? selectedValue;

  final FocusNode dropDownFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown<String>(
      name: widget.name,
      items: List.generate(
        widget.items.length + 1,
        (idx) => idx < widget.items.length
            ? DropdownMenuItem<String>(
                value: widget.items[idx].id.toString(),
                child: Text(widget.items[idx].exerciseNameId.toString()),
              )
            : DropdownMenuItem<String>(
                value: 'create',
                child: TextButton(child: Text('Create'), onPressed: () {}),
              ),
      ),
      focusNode: dropDownFocus,
      isExpanded: true,
      onChanged: (String? value) {
        setState(() {
          selectedValue = value;
        });
      },
    );
  }
}
