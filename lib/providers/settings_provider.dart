import 'package:flutter/material.dart';
import '../data/preferences/preference_helper.dart';
import '../utils/background_service.dart';

class SettingsProvider extends ChangeNotifier {
  final PreferenceHelper preferenceHelper;

  SettingsProvider({required this.preferenceHelper}) {
    _isDarkTheme = preferenceHelper.isDarkTheme;
    _isDailyReminderActive = preferenceHelper.isDailyReminderActive;
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  ThemeMode get themeMode => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggleTheme(bool value) async {
    _isDarkTheme = value;
    await preferenceHelper.setDarkTheme(value);
    notifyListeners();
  }

  Future<void> toggleDailyReminder(bool value) async {
    _isDailyReminderActive = value;
    await preferenceHelper.setDailyReminder(value);
    if (value) {
      await BackgroundService.enableDailyReminder();
    } else {
      await BackgroundService.disableDailyReminder();
    }
    notifyListeners();
  }
}
