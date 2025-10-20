import 'package:flutter/material.dart';

class Module {
  final String title;
  final String subject;
  final String chapter;
  final String description;
  final int pages;
  final int hours;
  final int exercises;
  final double progress;
  final IconData icon;

  Module({
    required this.title,
    required this.subject,
    required this.chapter,
    required this.description,
    required this.pages,
    required this.hours,
    required this.exercises,
    required this.progress,
    required this.icon,
  });
}