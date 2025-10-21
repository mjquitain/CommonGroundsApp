import 'package:flutter/material.dart';

class ClassModel {
  final String name;
  final String subject;
  final String time;
  final String location;
  final String status;
  final IconData icon;

  const ClassModel({
    required this.name,
    required this.subject,
    required this.time,
    required this.location,
    required this.status,
    required this.icon
  });
}