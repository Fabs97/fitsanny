import 'package:fitsanny/bloc/exercise_name/exercise_name_cubit.dart';
import 'package:fitsanny/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ExerciseForm extends StatelessWidget {
  final Function(int)? onComplete;
  final _formKey = GlobalKey<FormBuilderState>();

  ExerciseForm({super.key, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseNameCubit, ExerciseNamesState>(
      builder: (context, state) {
        if (state is! ExerciseNamesLoaded) {
          return Center(child: Text(AppLocalizations.of(context)!.loading));
        }
        return FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: [
              FormBuilderTextField(
                name: 'exercise_name',
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.exerciseNameLabel,
                ),
              ),
              TextButton(
                onPressed: () {
                  final name =
                      _formKey.currentState?.fields['exercise_name']?.value ??
                      '';
                  if (name.isNotEmpty) {
                    context.read<ExerciseNameCubit>().addExerciseName(
                      name,
                      onComplete: (id) {
                        // propagate to optional callback passed by caller
                        onComplete?.call(id);
                      },
                    );
                    Navigator.pop(
                      context,
                    ); // Bloc handles refresh automatically
                  }
                },
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          ),
        );
      },
    );
  }
}
