// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String homeGreeting(String timeOfDay) {
    return 'Buon $timeOfDay, Sanny 🧚🏼‍♀️';
  }

  @override
  String get homeTimeOfDayMorning => 'Giorno';

  @override
  String get homeTimeOfDayAfternoon => 'Pomeriggio';

  @override
  String get homeTimeOfDayEvening => 'Sera';

  @override
  String get homeSubtitle => '☀️ Sembra un ottimo momento per allenarsi ☀️';

  @override
  String get noGoalsSet =>
      'Nessun obiettivo impostato. Vai su Profilo > Obiettivi per aggiungerne uno!';

  @override
  String goalCurrent(double current) {
    final intl.NumberFormat currentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String currentString = currentNumberFormat.format(current);

    return 'Attuale: ${currentString}kg';
  }

  @override
  String goalTarget(double target) {
    final intl.NumberFormat targetNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String targetString = targetNumberFormat.format(target);

    return 'Obiettivo: ${targetString}kg';
  }

  @override
  String reps(int count) {
    return '$count rip.';
  }

  @override
  String get trainingHistoryTitle => 'Cronologia Allenamenti';

  @override
  String get noLogsFound => 'Nessun registro trovato per gli ultimi 30 giorni.';

  @override
  String setsCount(int count) {
    return '$count serie';
  }

  @override
  String get dateLabel => 'Data';

  @override
  String get removeSet => 'Rimuovi una serie';

  @override
  String get addSet => 'Aggiungi un\'altra serie!';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get myGoalsTitle => 'I Miei Obiettivi';

  @override
  String get noGoalsSetYet => 'Nessun obiettivo impostato.';

  @override
  String goalSubtitle(int reps, double kgs) {
    return '$reps rip. @ $kgs kg';
  }

  @override
  String get addGoalTitle => 'Aggiungi Obiettivo';

  @override
  String get editGoalTitle => 'Modifica Obiettivo';

  @override
  String get exerciseLabel => 'Esercizio';

  @override
  String get targetRepsLabel => 'Rip. Obiettivo';

  @override
  String get targetKgsLabel => 'Kg Obiettivo';

  @override
  String get loading => 'Caricamento...';

  @override
  String get saveExercise => 'Salva Esercizio';

  @override
  String get updateTrainingTitle => 'Aggiorna Allenamento';

  @override
  String get noTrainingsAvailable =>
      'Nessun allenamento disponibile, aggiungine uno ora!';

  @override
  String get loadingTrainings => 'Caricamento allenamenti...';

  @override
  String get addTraining => 'Aggiungi Allenamento';

  @override
  String get exerciseNameLabel => 'Nome Esercizio';

  @override
  String get titleLabel => 'Titolo';

  @override
  String get descriptionLabel => 'Descrizione';

  @override
  String get addExercise => 'Aggiungi Esercizio';

  @override
  String get chooseTrainingHint => 'Scegli un allenamento...';

  @override
  String setLabel(int count) {
    return 'Serie #$count';
  }

  @override
  String get kgsLabel => 'kg';

  @override
  String get repsLabel => 'rip.';

  @override
  String errorPrefix(String message) {
    return 'Errore: $message';
  }

  @override
  String get homeTooltip => 'Home';

  @override
  String get trainingTooltip => 'Allenamento';

  @override
  String get logTooltip => 'Registro';

  @override
  String get goalsTooltip => 'Obiettivi';

  @override
  String get pleaseChooseTraining => 'Scegli prima un allenamento';
}
