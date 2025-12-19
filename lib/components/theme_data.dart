
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryPurple = Color(0xFF6B32F8);
  static const Color backgroundColor = Color(0xFFF8F2FD);
  static const Color googleBlue = Color(0xFF32BCF4);
  static const Color gradientStart = Color(0xFF829BFF);
  static const Color gradientEnd = Color(0xFFD68AF4);
  static const Color iconColor = Color(0xFFE37E4A);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
  );

  // Text Styles
  static TextStyle headingStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static TextStyle bodyStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
    static TextStyle cardBody = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 10.8,
  );
  static TextStyle cardTitle = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  static TextStyle linkStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: primaryPurple,
  );

  static TextStyle buttonStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.white,
  );

  // Input Decoration
  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
    );
  }

  // Container Decoration for Input Fields
  static BoxDecoration inputContainerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Button Decoration
  static BoxDecoration buttonDecorationPrimary = BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );

    static BoxDecoration buttonDecorationSecondary = BoxDecoration(
    color: primaryPurple,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryPurple,
        secondary: googleBlue,
        surface: backgroundColor,
      ),
      textTheme: TextTheme(
        headlineSmall: headingStyle,
        bodyLarge: bodyStyle,
        labelLarge: buttonStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: buttonStyle,
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
    );
  }
}