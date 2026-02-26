import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({required this.onNumber, super.key});
  final ValueChanged<int> onNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        9,
        (index) {
          final number = index + 1;
          return InkWell(
            onTap: () => onNumber(number),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
