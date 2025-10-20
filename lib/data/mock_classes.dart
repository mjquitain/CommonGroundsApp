import 'package:flutter/material.dart';
import 'package:commongrounds/model/class.dart';

final List<ClassModel> mockClasses = [
  ClassModel(
    name: 'Data Structures',
    subject: 'CS 201',
    time: '9:00 AM - 10:30 AM',
    location: 'Room 204',
    status: 'Ongoing',
    icon: Icons.computer,
  ),
  ClassModel(
    name: 'Linear Algebra',
    subject: 'MATH 210',
    time: '11:00 AM - 12:30 PM',
    location: 'Room 305',
    status: 'Upcoming',
    icon: Icons.calculate,
  ),
  ClassModel(
    name: 'Psychology 101',
    subject: 'PSY 101',
    time: '1:00 PM - 2:30 PM',
    location: 'Room 112',
    status: 'Cancelled',
    icon: Icons.psychology_alt,
  ),
];