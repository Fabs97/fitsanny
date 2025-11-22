import 'package:fitsanny/router.dart';
import 'package:fitsanny/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fitsanny/l10n/app_localizations.dart';
import 'package:fitsanny/bloc/settings/settings_cubit.dart';
import 'package:fitsanny/bloc/settings/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Fit Sanny',
          theme: appTheme,
          routerConfig: router,
          locale: state.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('de'), Locale('it')],
        );
      },
    );
  }
}
