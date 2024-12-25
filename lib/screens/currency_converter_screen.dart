import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../widgets/currency_dropdown.dart';

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController amountController = TextEditingController();
  List<String> currencies = [];
  String? fromCurrency;
  String? toCurrency;
  String result = '';

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    final fetchedCurrencies = await CurrencyService.fetchCurrencies();
    setState(() {
      currencies = fetchedCurrencies;
      if (currencies.isNotEmpty) {
        fromCurrency = currencies.first;
        toCurrency = currencies[1];
      }
    });
  }

  Future<void> convertCurrency() async {
    if (fromCurrency == null ||
        toCurrency == null ||
        amountController.text.isEmpty) {
      setState(() {
        result = 'Please fill in all fields.';
      });
      return;
    }

    final amount = double.tryParse(amountController.text);
    if (amount == null) {
      setState(() {
        result = 'Invalid amount.';
      });
      return;
    }

    final conversionResult = await CurrencyService.convertCurrency(
      fromCurrency!,
      toCurrency!,
      amount,
    );

    setState(() {
      result = conversionResult != null
          ? '${amount.toStringAsFixed(2)} ${fromCurrency!.toUpperCase()} = ${conversionResult.convertedAmount.toStringAsFixed(2)} ${toCurrency!.toUpperCase()}'
          : 'Error during conversion.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 232, 239),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 232, 239),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Currency Converter',
              style: TextStyle(
                  fontSize: 25,
                  color: Color(0xff1F2261),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: currencies.isEmpty
          ? Center(
              child: Image.asset(
              "assets/images/exchange.gif",
              height: 50,
            ))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CurrencyDropdown(
                              value: fromCurrency,
                              items: currencies,
                              onChanged: (value) =>
                                  setState(() => fromCurrency = value),
                              label: 'From',
                            ),
                            const SizedBox(height: 12),
                            CurrencyDropdown(
                              value: toCurrency,
                              items: currencies,
                              onChanged: (value) =>
                                  setState(() => toCurrency = value),
                              label: 'To',
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: amountController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Enter Amount',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff989898),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                              ),
                            ),
                            // TextField(
                            //   controller: amountController,
                            //   keyboardType: TextInputType.number,
                            //   decoration:
                            //       const InputDecoration(labelText: 'Amount'),
                            // ),
                            const SizedBox(height: 20),
                            Text(
                              result,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.52,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Color(0xff26278D),
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        onPressed: convertCurrency,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Convert',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.transparent,
                          disabledForegroundColor:
                              Colors.transparent.withOpacity(0.38),
                          disabledBackgroundColor:
                              Colors.transparent.withOpacity(0.12),
                          shadowColor: Colors.transparent,
                          //make color or elevated button transparent
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
