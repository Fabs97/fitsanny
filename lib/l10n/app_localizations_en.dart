// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String homeGreeting(String timeOfDay) {
    return 'Good $timeOfDay, Sanny 🧚🏼‍♀️';
  }

  @override
  String get homeTimeOfDayMorning => 'Morning';

  @override
  String get homeTimeOfDayAfternoon => 'Afternoon';

  @override
  String get homeTimeOfDayEvening => 'Evening';

  @override
  String get homeSubtitle => '☀️ Looks like a great moment for a training ☀️';

  @override
  String get noGoalsSet =>
      'No goals set yet. Go to Profile > Goals to add some!';

  @override
  String goalCurrent(double current) {
    final intl.NumberFormat currentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String currentString = currentNumberFormat.format(current);

    return 'Current: ${currentString}kg';
  }

  @override
  String goalTarget(double target) {
    final intl.NumberFormat targetNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String targetString = targetNumberFormat.format(target);

    return 'Goal: ${targetString}kg';
  }

  @override
  String reps(int count) {
    return '$count reps';
  }

  @override
  String get trainingHistoryTitle => 'Training History';

  @override
  String get noLogsFound => 'No logs found for the last 30 days.';

  @override
  String setsCount(int count) {
    return '$count sets';
  }

  @override
  String get dateLabel => 'Date';

  @override
  String get removeSet => 'Remove a set';

  @override
  String get addSet => 'Add one more set!';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get myGoalsTitle => 'My Goals';

  @override
  String get noGoalsSetYet => 'No goals set yet.';

  @override
  String goalSubtitle(int reps, double kgs) {
    return '$reps reps @ $kgs kg';
  }

  @override
  String get addGoalTitle => 'Add Goal';

  @override
  String get editGoalTitle => 'Edit Goal';

  @override
  String get exerciseLabel => 'Exercise';

  @override
  String get targetRepsLabel => 'Target Reps';

  @override
  String get targetKgsLabel => 'Target Kgs';

  @override
  String get loading => 'Loading...';

  @override
  String get saveExercise => 'Save Exercise';

  @override
  String get updateTrainingTitle => 'Update Training';

  @override
  String get noTrainingsAvailable => 'No trainings available, add one now!';

  @override
  String get loadingTrainings => 'Loading trainings...';

  @override
  String get addTraining => 'Add Training';

  @override
  String get exerciseNameLabel => 'Exercise Name';

  @override
  String get titleLabel => 'Title';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get addExercise => 'Add Exercise';

  @override
  String get chooseTrainingHint => 'Choose a training...';

  @override
  String setLabel(int count) {
    return 'Set #$count';
  }

  @override
  String get kgsLabel => 'kgs';

  @override
  String get repsLabel => 'reps';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get homeTooltip => 'Home';

  @override
  String get trainingTooltip => 'Training';

  @override
  String get logTooltip => 'Log';

  @override
  String get goalsTooltip => 'Goals';

  @override
  String get pleaseChooseTraining => 'Please choose a training first';
}
