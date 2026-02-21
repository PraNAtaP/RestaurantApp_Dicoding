import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  final SharedPreferences sharedPreferences;

  PreferenceHelper({required this.sharedPreferences});

  static const String _darkThemeKey = 'DARK_THEME';
  static const String _dailyReminderKey = 'DAILY_REMINDER';

  bool get isDarkTheme => sharedPreferences.getBool(_darkThemeKey) ?? false;

  Future<void> setDarkTheme(bool value) async {
    await sharedPreferences.setBool(_darkThemeKey, value);
  }

  bool get isDailyReminderActive =>
      sharedPreferences.getBool(_dailyReminderKey) ?? false;

  Future<void> setDailyReminder(bool value) async {
    await sharedPreferences.setBool(_dailyReminderKey, value);
  }
}
