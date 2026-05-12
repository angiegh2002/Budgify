import 'dart:convert';
import 'package:budgify/services/cache_helper.dart';
import 'package:budgify/services/currency_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CurrencyProvider extends ChangeNotifier {

  String selectedCurrency =
      CacheHelper.prefs.getString("currency") ?? "USD";

  Map<String, double> rates = {
    "USD": 1.0,
  };

  List<String> currencies = [];

  bool loading = false;

  String? message;
  bool isMessageSuccess = true;

  CurrencyProvider() {
    loadCachedRates();
    loadRates();
  }

  Future<void> loadCachedRates() async {
    final cached = CacheHelper.prefs.getString("rates");

    if (cached != null) {
      final decoded = jsonDecode(cached);

      rates = decoded.map<String, double>(
            (key, value) => MapEntry(
          key,
          (value as num).toDouble(),
        ),
      );

      currencies = rates.keys.toList();
      notifyListeners();
    }
  }

  Future<void> loadRates() async {
    loading = true;
    message = null;
    notifyListeners();

    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      loading = false;
      message = "No internet connection. Currency conversion is currently unavailable.";
      isMessageSuccess = false;
      notifyListeners();
      return;
    }

    try {
      final result = await CurrencyService.getAllRates("USD");

      if (result != null) {
        rates = result.map<String, double>(
              (k, v) => MapEntry(
            k,
            (v as num).toDouble(),
          ),
        );

        currencies = rates.keys.toList();

        await CacheHelper.prefs.setString(
          "rates",
          jsonEncode(rates),
        );

        message = "Exchange rates updated successfully.";
        isMessageSuccess = true;
      } else {
        message = "Failed to update exchange rates. Using last saved values.";
        isMessageSuccess = false;
      }
    } catch (e) {
      message = "Failed to update exchange rates. Using last saved values.";
      isMessageSuccess = false;
    }

    loading = false;
    notifyListeners();
  }

  Future<void> changeCurrency(
      String newCurrency,
      BuildContext context,
      ) async {
    selectedCurrency = newCurrency;

    await CacheHelper.prefs.setString("currency", newCurrency);
    await loadRates();
    notifyListeners();

    if (message != null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(message!),
      //     backgroundColor: isMessageSuccess ? Colors.green : Colors.orange,
      //     behavior: SnackBarBehavior.floating,
      //     duration: const Duration(seconds: 3),
      //   ),
      // );
    }
  }

  double convert(double amount, String from, String to) {
    final fromRate = rates[from] ?? 1.0;
    final toRate = rates[to] ?? 1.0;
    double usd = amount / fromRate;
    return usd * toRate;
  }
}