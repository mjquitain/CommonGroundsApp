import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  static final TextStyle title = GoogleFonts.openSans(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static final TextStyle heading1 = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static final TextStyle heading2 = GoogleFonts.openSans(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );

  static final TextStyle body = GoogleFonts.playfairDisplay(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );

  static final TextStyle bodySmall = GoogleFonts.openSans(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );

  static final TextStyle button = GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static final TextStyle caption = GoogleFonts.playfairDisplay(
    fontSize: 12,
    color: AppColors.textDark,
  );
}
