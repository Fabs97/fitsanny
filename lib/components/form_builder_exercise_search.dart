import 'package:fitsanny/model/exercise_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// A custom FormBuilder field for searchable exercise selection
/// This avoids the setState during build issues by not extending FormBuilderField
class FormBuilderExerciseSearch extends StatefulWidget {
  final String name;
  final List<ExerciseName> items;
  final String? labelText;
  final int? initialValue;
  final FormFieldValidator<int>? validator;
  final ValueChanged<int?>? onChanged;

  const FormBuilderExerciseSearch({
    super.key,
    required this.name,
    required this.items,
    this.labelText,
    this.initialValue,
    this.validator,
    this.onChanged,
  });

  @override
  State<FormBuilderExerciseSearch> createState() =>
      _FormBuilderExerciseSearchState();
}

class _FormBuilderExerciseSearchState extends State<FormBuilderExerciseSearch> {
  final SearchController _searchController = SearchController();
  int? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _updateSearchText();
  }

  @override
  void didUpdateWidget(FormBuilderExerciseSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _currentValue = widget.initialValue;
      _updateSearchText();
    }
  }

  void _updateSearchText() {
    if (_currentValue != null) {
      final found = widget.items
          .where((e) => e.id == _currentValue)
          .firstOrNull;
      if (found != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _searchController.text = found.name;
          }
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _searchController.clear();
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Register this field with the FormBuilder
    return FormBuilderField<int>(
      name: widget.name,
      initialValue: widget.initialValue,
      validator: widget.validator,
      builder: (FormFieldState<int> field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: field.errorText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          child: SearchAnchor(
            searchController: _searchController,
            viewHintText: 'Choose an exercise',
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                hintText: 'Choose an exercise',
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 8.0),
                ),
                elevation: const WidgetStatePropertyAll(0.0),
                onTap: () => controller.openView(),
                onChanged: (_) => controller.openView(),
                trailing: const [Icon(Icons.search)],
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  final String input = controller.value.text.toLowerCase();
                  final filtered = widget.items.where((e) {
                    return e.name.toLowerCase().contains(input);
                  }).toList();

                  if (filtered.isEmpty) {
                    return [const ListTile(title: Text('No exercises found'))];
                  }

                  return filtered.map((e) {
                    return ListTile(
                      title: Text(e.name),
                      onTap: () {
                        // Close view immediately
                        controller.closeView(e.name);

                        // Update state after a delay
                        Future.delayed(Duration.zero, () {
                          if (mounted) {
                            setState(() {
                              _currentValue = e.id;
                            });
                            field.didChange(e.id);
                            widget.onChanged?.call(e.id);
                          }
                        });
                      },
                    );
                  }).toList();
                },
          ),
        );
      },
    );
  }
}
