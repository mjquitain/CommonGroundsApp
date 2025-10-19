import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Text(
          "Calendar",
          style: AppTypography.heading1.copyWith(
            color: AppColors.icon,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
