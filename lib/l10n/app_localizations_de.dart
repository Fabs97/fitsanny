// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String homeGreeting(String timeOfDay) {
    return 'Guten $timeOfDay, Sanny 🧚🏼‍♀️';
  }

  @override
  String get homeTimeOfDayMorning => 'Morgen';

  @override
  String get homeTimeOfDayAfternoon => 'Nachmittag';

  @override
  String get homeTimeOfDayEvening => 'Abend';

  @override
  String get homeSubtitle =>
      '☀️ Sieht nach einem großartigen Moment für ein Training aus ☀️';

  @override
  String get noGoalsSet =>
      'Noch keine Ziele gesetzt. Gehe zu Profil > Ziele, um welche hinzuzufügen!';

  @override
  String goalCurrent(double current) {
    final intl.NumberFormat currentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String currentString = currentNumberFormat.format(current);

    return 'Aktuell: ${currentString}kg';
  }

  @override
  String goalTarget(double target) {
    final intl.NumberFormat targetNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String targetString = targetNumberFormat.format(target);

    return 'Ziel: ${targetString}kg';
  }

  @override
  String reps(int count) {
    return '$count Wdh.';
  }

  @override
  String get trainingHistoryTitle => 'Trainingsverlauf';

  @override
  String get noLogsFound => 'Keine Einträge für die letzten 30 Tage gefunden.';

  @override
  String setsCount(int count) {
    return '$count Sätze';
  }

  @override
  String get dateLabel => 'Datum';

  @override
  String get removeSet => 'Satz entfernen';

  @override
  String get addSet => 'Noch einen Satz hinzufügen!';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get myGoalsTitle => 'Meine Ziele';

  @override
  String get noGoalsSetYet => 'Noch keine Ziele gesetzt.';

  @override
  String goalSubtitle(int reps, double kgs) {
    return '$reps Wdh. @ $kgs kg';
  }

  @override
  String get addGoalTitle => 'Ziel hinzufügen';

  @override
  String get editGoalTitle => 'Ziel bearbeiten';

  @override
  String get exerciseLabel => 'Übung';

  @override
  String get targetRepsLabel => 'Ziel-Wdh.';

  @override
  String get targetKgsLabel => 'Ziel-Kgs';

  @override
  String get loading => 'Laden...';

  @override
  String get saveExercise => 'Übung speichern';

  @override
  String get updateTrainingTitle => 'Training aktualisieren';

  @override
  String get noTrainingsAvailable =>
      'Keine Trainings verfügbar, füge jetzt eins hinzu!';

  @override
  String get loadingTrainings => 'Lade Trainings...';

  @override
  String get addTraining => 'Training hinzufügen';

  @override
  String get exerciseNameLabel => 'Übungsname';

  @override
  String get titleLabel => 'Titel';

  @override
  String get descriptionLabel => 'Beschreibung';

  @override
  String get addExercise => 'Übung hinzufügen';

  @override
  String get chooseTrainingHint => 'Wähle ein Training...';

  @override
  String setLabel(int count) {
    return 'Satz #$count';
  }

  @override
  String get kgsLabel => 'kg';

  @override
  String get repsLabel => 'Wdh.';

  @override
  String errorPrefix(String message) {
    return 'Fehler: $message';
  }

  @override
  String get homeTooltip => 'Startseite';

  @override
  String get trainingTooltip => 'Training';

  @override
  String get logTooltip => 'Protokoll';

  @override
  String get goalsTooltip => 'Ziele';

  @override
  String get pleaseChooseTraining => 'Bitte wähle zuerst ein Training';

  @override
  String get goalTypeLabel => 'Zieltyp';

  @override
  String get goalTypeReps => 'Wiederholungen';

  @override
  String get goalTypeWeight => 'Gewicht';
}
