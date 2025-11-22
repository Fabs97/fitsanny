import 'package:bloc/bloc.dart';
import 'package:fitsanny/bloc/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsInitial(Locale('en')));

  static const String _languageKey = 'language_code';

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);

    if (languageCode != null) {
      emit(SettingsLoaded(Locale(languageCode)));
    } else {
      // Default to English if no preference is saved
      // In a real app, you might want to check Platform.localeName
      emit(const SettingsLoaded(Locale('en')));
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    emit(SettingsLoaded(locale));
  }
}
