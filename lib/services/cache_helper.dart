import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String getCurrency() {
    return CacheHelper.prefs.getString("currency") ?? "USD";
  }

  static Future<void> saveUserData({
    required String name,
    required String userName,
    required String email,
    required String password,
  }) async {

    Map<String, dynamic> userData = {
      "name": name,
      "userName": userName,
      "email": email,
      "password": password,
    };

    await prefs.setString(
      "userData",
      jsonEncode(userData),
    );
  }

  static Map<String, dynamic>? getUserData() {

    final userDataString =
    prefs.getString("userData");

    if (userDataString == null) {
      return null;
    }

    return jsonDecode(userDataString);
  }



  static Future<void> saveMonthlyBudget(
      double budget) async {

    await prefs.setDouble(
      "monthlyBudget",
      budget,
    );
  }

  static double getMonthlyBudget() {

    return prefs.getDouble(
      "monthlyBudget",
    ) ??
        0;
  }

  static Future<void> saveBudgetAlert(
      bool value) async {

    await prefs.setBool(
      "budgetAlert",
      value,
    );
  }

  static bool getBudgetAlert() {

    return prefs.getBool(
      "budgetAlert",
    ) ??
        false;
  }
}