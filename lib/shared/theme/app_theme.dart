import 'package:flutter/material.dart';

class AppTheme {
  // Brand Palette (requested 4 colors)
  // 1. #070707 (near-black)
  // 2. #3FCD36 (green)
  // 3. #D95639 (danger)
  // 4. #F8F8F8 (light background)
  static const Color brandBlack = Color(0xFF28282b);
  static const Color brandGreen = Color(0xFF3FCD36);
  static const Color brandDanger = Color(0xFFDA563A);
  static const Color brandBg = Color(0xFFF8F8F8);
  static const Color brandSkin = Color(0xFFFCD36A);
  static const Color brandBullet = Color(0xFFEFEFEF);
  static const Color errorRed = brandDanger;
  static const Color warningOrange =
      brandDanger; // constrain to requested palette
  static const Color successGreen = brandGreen;
  static const Color primaryBlue = brandGreen; // primary accent

  // Fonts and Typography
  static const double mainHeading = 38;
  static const double titleFont = 24;

  // Card shadow used across the app for consistent elevation styling
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000), // ~10% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Elevated button
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: AppTheme.brandBlack,
    foregroundColor: AppTheme.brandBg,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    textStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 10,
    ),
  );

  // Outlined Button
  static final ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    side: const BorderSide(color: AppTheme.brandBlack),
    foregroundColor: AppTheme.brandBlack,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    textStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 10,
    ),
  );


  // Box Decoration for dashboard tiles
  static BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    boxShadow: cardShadow,
    color: brandBg,
  );
  
}
