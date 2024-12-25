import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String label;

  const CurrencyDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff989898),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
                size: 24,
              ),
              items: items.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(
                    currency.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xff1F2261),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
