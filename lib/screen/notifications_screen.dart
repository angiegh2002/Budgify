import 'package:flutter/material.dart';
import '../const.dart';
import '../server/cache_helper.dart';
import '../server/notification_server.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}
class _NotificationsScreenState extends State<NotificationsScreen> {
  bool enableNotifications = true;
  bool dailyReminder = true;
  bool budgetAlert = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    enableNotifications = CacheHelper.prefs.getBool("enableNotifications") ?? true;
    dailyReminder = CacheHelper.prefs.getBool("dailyReminder") ?? true;
    budgetAlert = CacheHelper.prefs.getBool("budgetAlert") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Enable notifications",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Switch(
                    value: enableNotifications,
                    activeColor: green,
                    inactiveThumbColor: gray4,
                    onChanged: (value) async {
                      setState(() {
                        enableNotifications = value;
                        if (!value) {
                          dailyReminder = false;
                          budgetAlert = false;
                        }
                      });

                      CacheHelper.prefs.setBool("enableNotifications", value);
                      CacheHelper.prefs.setBool("dailyReminder", dailyReminder);
                      CacheHelper.prefs.setBool("budgetAlert", budgetAlert);

                      if (!value) {
                        await NotificationService.setDailyReminder(false);
                      } else {
                        if (dailyReminder) {
                          await NotificationService.setDailyReminder(true);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 2. Options Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Daily Reminder
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: dailyReminder,
                    activeColor: green,
                    title: const Text("Daily Reminder"),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: enableNotifications
                        ? (value) async {
                      setState(() => dailyReminder = value!);
                      CacheHelper.prefs.setBool("dailyReminder", value!);
                      await NotificationService.setDailyReminder(value);
                    }
                        : null,
                  ),

                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: budgetAlert,
                    activeColor: green,
                    title: const Text("Budget Alert"),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: enableNotifications
                        ? (value) async {
                      setState(() => budgetAlert = value!);
                      CacheHelper.prefs.setBool("budgetAlert", value!);

                      await NotificationService.budgetAlert(0.0, value!);
                    }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}