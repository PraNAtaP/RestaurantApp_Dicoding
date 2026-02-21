import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import '../data/models/restaurant_model.dart';
import 'notification_helper.dart';

const String dailyReminderTask = 'daily_reminder_task';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == dailyReminderTask) {
        final response = await http.get(
          Uri.parse('https://restaurant-api.dicoding.dev/list'),
        );
        if (response.statusCode == 200) {
          final data = RestaurantListResponse.fromJson(
            json.decode(response.body),
          );
          await NotificationHelper.initNotifications();
          await NotificationHelper.showRandomRestaurantNotification(
            data.restaurants,
          );
        }
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

class BackgroundService {
  static Future<void> initializeWorkmanager() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> enableDailyReminder() async {
    await Workmanager().registerPeriodicTask(
      '1',
      dailyReminderTask,
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  static Future<void> disableDailyReminder() async {
    await Workmanager().cancelByUniqueName('1');
  }

  static Duration _calculateInitialDelay() {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);
    if (now.isAfter(scheduledTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    return scheduledTime.difference(now);
  }
}
