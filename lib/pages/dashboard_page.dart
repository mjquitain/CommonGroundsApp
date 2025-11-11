import 'package:commongrounds/model/detailed_task.dart';
import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/widgets/task_card_compact.dart';
import 'package:commongrounds/widgets/class_card.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:commongrounds/widgets/task_preview_sheet.dart';
import 'package:commongrounds/data/mock_detailed_tasks.dart';
import 'package:commongrounds/data/mock_classes.dart';
import 'package:commongrounds/model/class.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final detailedtask = mockDetailedTasks;
  final classes = mockClasses;

  int _dayToWeekday(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        return 0; // Invalid
    }
  }

  List<ClassModel> getTodaysClasses() {
    final now = DateTime.now();
    final todayWeekday = now.weekday;

    final todaysClasses = classes.where((c) {
      final classWeekday = _dayToWeekday(c.day);
      return classWeekday == todayWeekday;
    }).toList();

    return todaysClasses;
  }

  List<DetailedTask> getUpcomingTasks() {
    final now = DateTime.now();

    final actionableTasks = detailedtask.where((t) {
      final isUpcomingOrOverdue = t.deadline.isBefore(now.add(const Duration(days: 3))) ||
          t.deadline.isBefore(now);

      final isNotCompleted = t.status.toLowerCase() != 'completed';

      return isUpcomingOrOverdue && isNotCompleted;
    }).toList();

    actionableTasks.sort((a, b) => a.deadline.compareTo(b.deadline));

    return actionableTasks.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tasksToShow = getUpcomingTasks();
    final classesToShow = getTodaysClasses();
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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                            "Good to see you! You’ve got a few tasks waiting, and I’d suggest starting with the ones due soon so you don’t feel rushed later. Don’t forget to take care of yourself too — a short break or even a quick stretch can help you stay sharp.",
                            style: AppTypography.heading2.copyWith(
                              fontSize: 16,
                            ),
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
                    padding: const EdgeInsets.symmetric(vertical: 15), // Removed horizontal padding here as it's already in the parent Padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.schedule, color: Colors.black),
                            const SizedBox(width: 8),
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
                                  // Assuming TaskPreviewSheet is imported
                                  // and ClassPreviewSheet (from previous request) is needed here.
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
                    padding: const EdgeInsets.symmetric(vertical: 15),
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
                          padding: const EdgeInsets.only(left: 2),
                          child: classesToShow.isEmpty
                              ? Text(
                            "No classes scheduled for today.",
                            style: AppTypography.body.copyWith(color: Colors.grey),
                          )
                              : ListView.builder(
                                  itemCount: classesToShow.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final c = classesToShow[index];
                                    return ClassCard(classData: c);
                                  },
                                ),
                        ),
                      ],
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