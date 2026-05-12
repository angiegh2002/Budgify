import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

import '../const.dart';
import '../services/cache_helper.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
  FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    const android = AndroidInitializationSettings('logo');
    const settings = InitializationSettings(android: android);

    await plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
      },
    );

    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }


  static Future<void> setDailyReminder(bool enable) async {
    try {
      print(" setDailyReminder called with: enable=$enable");

      if (!enable) {
        await plugin.cancel(1);
        print("Daily reminder cancelled (ID: 1)");
        return;
      }

      final scheduledTime = _next8PM();
      final now = tz.TZDateTime.now(tz.local);

      print(" Current time: $now");
      print(" Scheduled time: $scheduledTime");
      print(" Difference: ${scheduledTime.difference(now).inMinutes} minutes from now");

      await plugin.zonedSchedule(
        1,
        "Budgify Reminder",
        "Don't forget to track your expenses today 💸",
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel',
            'Daily Reminder',
            channelDescription: 'Daily reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: 'logo',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      print(" Daily reminder scheduled successfully for: $scheduledTime");

    } catch (e, stack) {
      print(" Failed to schedule daily reminder: $e");
      print(" Stack trace: $stack");
    }
  }
  static Future<void> budgetAlert(double percent, bool enabled) async {
    if (!enabled) return;

    bool alreadySent =
        CacheHelper.prefs.getBool("budgetAlertSent") ?? false;

    if (percent >= 0.8 && !alreadySent) {
      await plugin.show(
        2,
        "Budget Alert ⚠️",
        "You used ${(percent * 100).toStringAsFixed(0)}% of your budget!",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'budget_channel',
            'Budget Alerts',
            channelDescription: 'Budget alert notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: 'logo',
          ),
        ),
      );

      await CacheHelper.prefs.setBool("budgetAlertSent", true);
    }

    if (percent < 0.8) {
      await CacheHelper.prefs.setBool("budgetAlertSent", false);
    }
  }

  static tz.TZDateTime _next8PM() {
    final now = tz.TZDateTime.now(tz.local);

    print("  [TIME DEBUG] Now: $now (timezone: ${tz.local.name})");

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20,
      0,
      0,
    );

    print(" [TIME DEBUG] Target 8PM today: $scheduled");

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
      print(" [TIME DEBUG] Adjusted to tomorrow: $scheduled");
    }

    print(" [TIME DEBUG] Final scheduled: $scheduled");
    print("[TIME DEBUG] Minutes from now: ${scheduled.difference(now).inMinutes}");

    return scheduled;
  }

  static Future<void> testScheduledIn30Seconds() async {
    final now = tz.TZDateTime.now(tz.local);
    final in30Seconds = now.add(const Duration(seconds: 30));

    print("  [TEST] Now: $now");
    print("  [TEST] Will fire at: $in30Seconds");

    await plugin.zonedSchedule(
      777,
      " اختبار سريع",
      "إذا ظهر هذا، فالجدولة تعمل! ✓",
      in30Seconds,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,

    );

    print("Test notification scheduled");
  }
}