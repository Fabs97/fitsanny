import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsState extends Equatable {
  final Locale locale;

  const SettingsState(this.locale);

  @override
  List<Object> get props => [locale];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial(super.locale);
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded(super.locale);
}
