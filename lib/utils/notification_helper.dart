import 'dart:math';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/models/restaurant_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationHelper {
  static const String _channelId = 'restaurant_channel';
  static const String _channelName = 'Restaurant Reminder';

  static Future<void> initNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(
      android: androidSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Daily restaurant recommendation',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  static Future<void> showRandomRestaurantNotification(
      List<Restaurant> restaurants) async {
    if (restaurants.isEmpty) return;
    final random = Random();
    final restaurant = restaurants[random.nextInt(restaurants.length)];
    await showNotification(
      id: 0,
      title: 'Restaurant Recommendation',
      body:
          '${restaurant.name} di ${restaurant.city} — Rating: ${restaurant.rating}',
      payload: json.encode(restaurant.toMap()),
    );
  }
}
