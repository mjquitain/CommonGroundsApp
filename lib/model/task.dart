import 'package:flutter/material.dart';

class Task {
  final String title;
  final String subject;
  final String description;
  final String deadline;
  final String priority;
  final String status;
  final double progress;
  final IconData icon;

  Task({
    required this.title,
    required this.subject,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.status,
    required this.progress,
    required this.icon,
  });
}