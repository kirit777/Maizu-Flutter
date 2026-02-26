import 'package:flutter/material.dart';

class StatsBar extends StatelessWidget {
  const StatsBar({
    required this.difficulty,
    required this.mistakes,
    required this.time,
    super.key,
  });

  final String difficulty;
  final int mistakes;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${difficulty.toLowerCase()} - 3',
            style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Text(
            'Mistake : $mistakes/10',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Text(
            time,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
