import 'package:flutter/material.dart';

class CornerRibbon extends StatelessWidget {
  final String text;
  const CornerRibbon({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Transform.rotate(
        angle: -0.785398, // -45 درجه
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          color: const Color(0xFFE53935),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
