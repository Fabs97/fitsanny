import 'package:fitsanny/bloc/settings/settings_cubit.dart';
import 'package:fitsanny/bloc/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsCubit', () {
    test('initial state is SettingsInitial with English locale', () {
      final cubit = SettingsCubit();
      expect(cubit.state, const SettingsInitial(Locale('en')));
      cubit.close();
    });

    test('loadSettings emits SettingsLoaded with saved locale', () async {
      SharedPreferences.setMockInitialValues({'language_code': 'it'});
      final cubit = SettingsCubit();
      await cubit.loadSettings();
      expect(cubit.state, const SettingsLoaded(Locale('it')));
      cubit.close();
    });

    test(
      'loadSettings emits SettingsLoaded with default locale if no preference',
      () async {
        SharedPreferences.setMockInitialValues({});
        final cubit = SettingsCubit();
        await cubit.loadSettings();
        expect(cubit.state, const SettingsLoaded(Locale('en')));
        cubit.close();
      },
    );

    test('changeLanguage saves preference and emits SettingsLoaded', () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = SettingsCubit();

      await cubit.changeLanguage(const Locale('de'));

      expect(cubit.state, const SettingsLoaded(Locale('de')));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('language_code'), 'de');
      cubit.close();
    });
  });
}
