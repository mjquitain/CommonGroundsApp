import 'package:flutter/material.dart';

class DetailedTask {
  final String title;
  final String subject;
  final String description;
  final DateTime deadline;
  final String priority;
  final String status;
  final double progress;
  final IconData icon;
  final String category;

  DetailedTask({
    required this.title,
    required this.subject,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.status,
    required this.progress,
    required this.icon,
    required this.category,
  });

  DetailedTask copyWith({
    String? title,
    String? subject,
    String? description,
    DateTime? deadline,
    String? priority,
    String? status,
    double? progress,
    IconData? icon,
    String? category,
  }) {
    return DetailedTask(
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      icon: icon ?? this.icon,
      category: category ?? this.category,
    );
  }
}
