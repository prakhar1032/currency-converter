import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  List<String> currencies = [];
  String? fromCurrency;
  String? toCurrency;
  TextEditingController amountController = TextEditingController();
  String result = '';

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    const url =
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currencies = (data['usd'] as Map<String, dynamic>).keys.toList();
          fromCurrency = currencies.first;
          toCurrency = currencies[1];
        });
      }
    } catch (error) {
      print('Error fetching currencies: $error');
    }
  }

  Future<void> convertCurrency() async {
    print(fromCurrency);
    print(toCurrency);
    print(amountController.text);
    if (fromCurrency == null ||
        toCurrency == null ||
        amountController.text.isEmpty) {
      setState(() {
        result = 'Please fill in all fields.';
        print(result);
      });
      return;
    }

    final amount = double.tryParse(amountController.text);
    if (amount == null) {
      setState(() {
        result = 'Invalid amount.';
        print(result);
      });
      return;
    }

    final url =
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/$fromCurrency.json';
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data['$fromCurrency'][toCurrency];
        final convertedAmount = amount * rate;

        setState(() {
          result =
              '$amount $fromCurrency = ${convertedAmount.toStringAsFixed(2)} $toCurrency';
        });
      }
    } catch (error) {
      print('Error converting currency: $error');
      setState(() {
        result = 'Error fetching conversion rate.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: currencies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButton<String>(
                    value: fromCurrency,
                    onChanged: (value) {
                      setState(() {
                        fromCurrency = value;
                      });
                    },
                    items: currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: toCurrency,
                    onChanged: (value) {
                      setState(() {
                        toCurrency = value;
                      });
                    },
                    items: currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: convertCurrency,
                    child: Text('Convert'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    result,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
