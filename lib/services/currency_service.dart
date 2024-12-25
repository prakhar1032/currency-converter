import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/conversion_result.dart';

class CurrencyService {
  static const String baseUrl =
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1';

  static Future<List<String>> fetchCurrencies() async {
    const url = '$baseUrl/currencies/usd.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['usd'] as Map<String, dynamic>).keys.toList();
      }
    } catch (e) {
      print('Error fetching currencies: $e');
    }
    return [];
  }

  static Future<ConversionResult?> convertCurrency(
      String fromCurrency, String toCurrency, double amount) async {
    final url = '$baseUrl/currencies/$fromCurrency.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data[fromCurrency][toCurrency];
        if (rate != null) {
          return ConversionResult(convertedAmount: amount * rate);
        }
      }
    } catch (e) {
      print('Error converting currency: $e');
    }
    return null;
  }
}
