import 'package:fitsanny/bloc/exercise_name/exercise_name_cubit.dart';
import 'package:fitsanny/bloc/training/training_cubit.dart';
import 'package:fitsanny/pages/training/exercise_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseDropdown extends StatefulWidget {
  const ExerciseDropdown({
    super.key,
    required this.name,
    required this.exerciseIndex,
  });

  final String name;
  final int exerciseIndex;

  @override
  State<ExerciseDropdown> createState() => _ExerciseDropdownState();
}

class _ExerciseDropdownState extends State<ExerciseDropdown> {
  final SearchController _searchController = SearchController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseNameCubit, ExerciseNamesState>(
      builder: (context, exerciseNameState) {
        if (exerciseNameState is ExerciseNamesError) {
          return Center(child: Text('Error: ${exerciseNameState.message}'));
        }
        return BlocBuilder<TrainingCubit, TrainingState>(
          builder: (context, trainingState) {
            if (trainingState is NewTraining) {
              final currentExercise =
                  trainingState.newTraining.exercises[widget.exerciseIndex];

              // Find current name to display
              String? currentName;
              if (exerciseNameState is ExerciseNamesLoaded) {
                final found = exerciseNameState.exerciseNames
                    .where((e) => e.id == currentExercise.exerciseNameId)
                    .firstOrNull;
                currentName = found?.name;
              }

              // Update controller text if it doesn't match
              // We use addPostFrameCallback to ensure the SearchAnchor is attached
              // before checking isOpen, avoiding "isAttached is not true" error.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                try {
                  if (currentName != null &&
                      _searchController.text != currentName) {
                    if (!_searchController.isOpen) {
                      _searchController.text = currentName;
                    }
                  } else if (currentExercise.exerciseNameId == 0 &&
                      !_searchController.isOpen) {
                    _searchController.clear();
                  }
                } catch (e) {
                  // Ignore if controller is not attached yet
                }
              });

              return Row(
                children: [
                  Expanded(
                    child: SearchAnchor(
                      searchController: _searchController,
                      viewHintText: 'Choose an exercise',
                      builder:
                          (BuildContext context, SearchController controller) {
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
                            if (exerciseNameState is! ExerciseNamesLoaded) {
                              return [
                                const ListTile(title: Text('Loading...')),
                              ];
                            }

                            final String input = controller.value.text
                                .toLowerCase();
                            final filtered = exerciseNameState.exerciseNames
                                .where((e) {
                                  return e.name.toLowerCase().contains(input);
                                })
                                .toList();

                            if (filtered.isEmpty) {
                              return [
                                const ListTile(
                                  title: Text('No exercises found'),
                                ),
                              ];
                            }

                            return filtered.map((e) {
                              return ListTile(
                                title: Text(e.name),
                                onTap: () {
                                  context
                                      .read<TrainingCubit>()
                                      .changeExerciseInNewTraining(
                                        widget.exerciseIndex,
                                        e.id,
                                      );
                                  controller.closeView(e.name);
                                },
                              );
                            }).toList();
                          },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 12.0,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Create new exercise'),
                          content: ExerciseForm(
                            onComplete: (id) {
                              context
                                  .read<TrainingCubit>()
                                  .changeExerciseInNewTraining(
                                    widget.exerciseIndex,
                                    id,
                                  );
                              // We might want to update the text here too,
                              // but the state rebuild should handle it if we find the name.
                              // However, the new name might not be in the loaded list instantly
                              // unless ExerciseNameCubit refreshes.
                              // Assuming ExerciseForm triggers a refresh or returns the ID
                              // and we rely on the list being updated.
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(
                  "ExerciseDropdown::build - Training State ${trainingState.runtimeType}",
                ),
              );
            }
          },
        );
      },
    );
  }
}
