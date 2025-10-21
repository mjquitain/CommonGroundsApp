import 'package:flutter/material.dart';
import 'package:commongrounds/model/module.dart';

final List<Module> mockModules = [
  Module(
    title: 'Module 1: Introduction to Psychology',
    subject: 'PSYCH 101',
    chapter: '1 – Understanding Human Behavior',
    description: 'Explore basic concepts of psychology and key figures in the field.',
    pages: 25,
    hours: 2,
    exercises: 5,
    progress: 0.3,
    icon: Icons.psychology,
  ),
  Module(
    title: 'Module 2: The Nervous System',
    subject: 'BIO 110',
    chapter: '2 – Neural Pathways',
    description: 'Learn how neurons communicate and how the brain processes information.',
    pages: 30,
    hours: 3,
    exercises: 8,
    progress: 0.5,
    icon: Icons.biotech,
  ),
];