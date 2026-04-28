import 'package:budgify/screen/login_screen.dart';
import 'package:budgify/server/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme_data.dart';
import 'const.dart';
import 'database/database_helper.dart';
import 'layout/home_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  await DatabaseHelper.insertDefaultCategories();
  bool isLogin =
      CacheHelper.prefs.getBool("isLogin") ?? false;
  await CacheHelper.prefs.setString("currency", "USD");

  runApp(BudgifyApp(isLogin: isLogin));
}
class BudgifyApp extends StatelessWidget {
  final bool isLogin;

  const BudgifyApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: isLogin
          ? HomeLayout()
          : LoginScreen(),
    );
  }
}