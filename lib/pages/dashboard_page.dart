import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/model/task.dart';
import 'package:commongrounds/model/class.dart';
import 'package:commongrounds/widgets/task_card_compact.dart';
import 'package:commongrounds/widgets/class_card.dart';
import 'package:commongrounds/theme/typography.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Task> tasks = [
    Task(
      title: 'Math Assignment - Calculus Problem Set',
      subject: 'MATH 201',
      description: 'Complete problems 1–25 from Chapter 7.',
      deadline: '2 days ago, Oct 13 2025',
      priority: 'High',
      status: 'Overdue',
      progress: 0.0,
      icon: Icons.calculate,
    ),
    Task(
      title: 'Physics Lab Report',
      subject: 'PHYS 102',
      description: 'Write lab report on electromagnetic field experiments. Include data analysis and conclusions.',
      deadline: 'Oct 20, 11:59 PM',
      priority: 'Medium',
      status: 'In Progress',
      progress: 0.4,
      icon: Icons.science,
    ),
    Task(
      title: 'History Essay Draft',
      subject: 'HIST 150',
      description: 'Write first draft of essay on Industrial Revolution impacts on society.',
      deadline: 'Oct 17, 11:59 PM',
      priority: 'Low',
      status: 'Not Started',
      progress: 1.0,
      icon: Icons.castle,
    ),
  ];

  final List<ClassModel> classes = [
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


  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        "Upcoming",
                        style: AppTypography.heading1.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: ListView.builder(
                      itemCount: tasks.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCardCompact(task: task);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),
            Container(
              width: 1000,
              height: 1.2,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        "Today's Classes",
                        style: AppTypography.heading1.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: ListView.builder(
                      itemCount: classes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final c = classes[index];
                        return ClassCard(classData: c);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Container(
              width: 1000,
              height: 1.2,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flutter_dash, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        "Wasi Talks",
                        style: AppTypography.heading1.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.textField.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Good to see you! You’ve got a few tasks waiting, and I’d suggest starting with the ones due soon so you don’t feel rushed later. Don’t forget to take care of yourself too — a short break or even a quick stretch can help you stay sharp. I also noticed you’ve got some free time this afternoon; would you like me to block a study session then so you can stay on track?",
                      style: AppTypography.heading2.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}