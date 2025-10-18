import 'package:commongrounds/model/detailed_task.dart';
import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/widgets/task_card_compact.dart';
import 'package:commongrounds/widgets/class_card.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:commongrounds/widgets/task_preview_sheet.dart';
import 'package:commongrounds/data/mock_detailed_tasks.dart';
import 'package:commongrounds/data/mock_classes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final detailedtask = mockDetailedTasks;
  final classes = mockClasses;

  List<DetailedTask> getUpcomingTasks() {
    final now = DateTime.now();
    final upcoming = detailedtask.where((t) {
      return t.deadline.isBefore(now.add(const Duration(days: 3))) ||
          t.deadline.isBefore(now);
    }).toList();

    upcoming.sort((a, b) => a.deadline.compareTo(b.deadline));

    return upcoming.take(5).toList();
  }


  @override
  Widget build(BuildContext context) {
    final tasksToShow = getUpcomingTasks();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        "Upcoming",
                        style: AppTypography.heading1.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (tasksToShow.isEmpty)
                    Text(
                      "No upcoming tasks.",
                      style: AppTypography.body.copyWith(color: Colors.grey),
                    )
                  else
                    ListView.builder(
                      itemCount: tasksToShow.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final task = tasksToShow[index];
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => TaskPreviewSheet(task: task),
                            );
                          },
                          child: TaskCardCompact(task: task),
                        );
                      },
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