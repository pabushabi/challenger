import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color accent = Color(0xFFE85D4C);

  static const List<Color> accentPalette = [
    Color(0xFFE85D4C),
    Color(0xFF2D6A4F),
    Color(0xFF1D3557),
    Color(0xFF457B9D),
    Color(0xFFE9C46A),
    Color(0xFFF4A261),
    Color(0xFF9B2226),
    Color(0xFF6A4C93),
    Color(0xFF0A9396),
    Color(0xFFBB3E03),
  ];

  static Color accentByIndex(int index) {
    if (index < 0 || index >= accentPalette.length) {
      return accent;
    }
    return accentPalette[index];
  }
}
