import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box settingsBox;

  ThemeCubit(this.settingsBox) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = settingsBox.get(HiveConstants.themeKey, defaultValue: false);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    settingsBox.put(HiveConstants.themeKey, newMode == ThemeMode.dark);
    emit(newMode);
  }

  void setTheme(ThemeMode mode) {
    settingsBox.put(HiveConstants.themeKey, mode == ThemeMode.dark);
    emit(mode);
  }

  bool get isDark => state == ThemeMode.dark;
}