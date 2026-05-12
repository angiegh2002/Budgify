import 'dart:convert';

import 'package:http/http.dart' as http;

class CurrencyService {
  static const String apiKey =
      "e310dcea75f091d523aa26c8";
  static Future<Map<String, double>?> getAllRates(String base) async {
    final url =
        "https://v6.exchangerate-api.com/v6/$apiKey/latest/$base";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final rates = data["conversion_rates"];

      return Map<String, double>.from(
        rates.map((k, v) => MapEntry(k, (v as num).toDouble())),
      );
    }

    return null;
  }
}