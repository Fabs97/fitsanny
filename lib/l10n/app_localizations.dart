import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good {timeOfDay}, Sanny 🧚🏼‍♀️'**
  String homeGreeting(String timeOfDay);

  /// No description provided for @homeTimeOfDayMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get homeTimeOfDayMorning;

  /// No description provided for @homeTimeOfDayAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get homeTimeOfDayAfternoon;

  /// No description provided for @homeTimeOfDayEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get homeTimeOfDayEvening;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'☀️ Looks like a great moment for a training ☀️'**
  String get homeSubtitle;

  /// No description provided for @noGoalsSet.
  ///
  /// In en, this message translates to:
  /// **'No goals set yet. Go to Profile > Goals to add some!'**
  String get noGoalsSet;

  /// No description provided for @goalCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current: {current}kg'**
  String goalCurrent(double current);

  /// No description provided for @goalTarget.
  ///
  /// In en, this message translates to:
  /// **'Goal: {target}kg'**
  String goalTarget(double target);

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String reps(int count);

  /// No description provided for @trainingHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Training History'**
  String get trainingHistoryTitle;

  /// No description provided for @noLogsFound.
  ///
  /// In en, this message translates to:
  /// **'No logs found for the last 30 days.'**
  String get noLogsFound;

  /// No description provided for @setsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sets'**
  String setsCount(int count);

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @removeSet.
  ///
  /// In en, this message translates to:
  /// **'Remove a set'**
  String get removeSet;

  /// No description provided for @addSet.
  ///
  /// In en, this message translates to:
  /// **'Add one more set!'**
  String get addSet;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @myGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Goals'**
  String get myGoalsTitle;

  /// No description provided for @noGoalsSetYet.
  ///
  /// In en, this message translates to:
  /// **'No goals set yet.'**
  String get noGoalsSetYet;

  /// No description provided for @goalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{reps} reps @ {kgs} kg'**
  String goalSubtitle(int reps, double kgs);

  /// No description provided for @addGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Goal'**
  String get addGoalTitle;

  /// No description provided for @editGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Goal'**
  String get editGoalTitle;

  /// No description provided for @exerciseLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseLabel;

  /// No description provided for @targetRepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Reps'**
  String get targetRepsLabel;

  /// No description provided for @targetKgsLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Kgs'**
  String get targetKgsLabel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @saveExercise.
  ///
  /// In en, this message translates to:
  /// **'Save Exercise'**
  String get saveExercise;

  /// No description provided for @updateTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Training'**
  String get updateTrainingTitle;

  /// No description provided for @noTrainingsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No trainings available, add one now!'**
  String get noTrainingsAvailable;

  /// No description provided for @loadingTrainings.
  ///
  /// In en, this message translates to:
  /// **'Loading trainings...'**
  String get loadingTrainings;

  /// No description provided for @addTraining.
  ///
  /// In en, this message translates to:
  /// **'Add Training'**
  String get addTraining;

  /// No description provided for @exerciseNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise Name'**
  String get exerciseNameLabel;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExercise;

  /// No description provided for @chooseTrainingHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a training...'**
  String get chooseTrainingHint;

  /// No description provided for @setLabel.
  ///
  /// In en, this message translates to:
  /// **'Set #{count}'**
  String setLabel(int count);

  /// No description provided for @kgsLabel.
  ///
  /// In en, this message translates to:
  /// **'kgs'**
  String get kgsLabel;

  /// No description provided for @repsLabel.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get repsLabel;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(String message);

  /// No description provided for @homeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTooltip;

  /// No description provided for @trainingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get trainingTooltip;

  /// No description provided for @logTooltip.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get logTooltip;

  /// No description provided for @goalsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goalsTooltip;

  /// No description provided for @pleaseChooseTraining.
  ///
  /// In en, this message translates to:
  /// **'Please choose a training first'**
  String get pleaseChooseTraining;

  /// No description provided for @goalTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal Type'**
  String get goalTypeLabel;

  /// No description provided for @goalTypeReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get goalTypeReps;

  /// No description provided for @goalTypeWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get goalTypeWeight;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
