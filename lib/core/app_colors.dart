import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color gold = Color(0xFFE2BE7F);
  static const Color black = Color(0xFF202020);
  static const Color brown = Color(0xFF856B3F);
  static const Color white = Colors.white;

  /// Selected tab pill in the bottom navigation bar (black @ 60%).
  static const Color navPill = Color(0x99202020);

  /// Gradient used on the prayer-time cards.
  static const LinearGradient prayerCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF202020), Color(0xFFB19768)],
  );
}
