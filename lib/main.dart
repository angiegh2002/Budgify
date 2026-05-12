import 'package:budgify/provider/currency_provider.dart';
import 'package:budgify/screen/login_screen.dart';
import 'package:budgify/services/cache_helper.dart';
import 'package:budgify/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:timezone/data/latest.dart';

import 'package:flutter_timezone/flutter_timezone.dart';

import 'app_theme_data.dart';
import 'const.dart';
import 'database/database_helper.dart';
import 'layout/home_layout.dart';

final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(appTheme);

void toggleTheme(bool isDark) {
  themeNotifier.value = isDark ? darkTheme : appTheme;
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await DatabaseHelper.insertDefaultCategories();
  initializeTimeZones();
  try {
    final deviceTimezone = await FlutterTimezone.getLocalTimezone();
    print("Detected Timezone: $deviceTimezone");
    final location = tz.getLocation(deviceTimezone);
    tz.setLocalLocation(location);

  } catch (e) {
    print("Fallback to UTC due to error: $e");
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  await NotificationService.init();

  bool isLogin = CacheHelper.prefs.getBool("isLogin") ?? false;
  bool isDarkmode = CacheHelper.prefs.getBool("enableDarkMode") ?? false;

  themeNotifier.value = isDarkmode ? darkTheme : appTheme;


  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ],
      child:BudgifyApp(isLogin: isLogin,isDarkmode: isDarkmode,)));
}

class BudgifyApp extends StatelessWidget {
  final bool isLogin;
  const BudgifyApp({super.key, required this.isLogin, required bool isDarkmode});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
          home: isLogin ? HomeLayout() : LoginScreen(),
        );
      },
    );
  }
}