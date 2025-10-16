import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';

class LearningHubPage extends StatefulWidget {
  const LearningHubPage({super.key});

  @override
  State<LearningHubPage> createState() => _LearningHubPageState();
}

class _LearningHubPageState extends State<LearningHubPage> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const Center(
          child: Text("Home Page Content")),
    );
  }
}