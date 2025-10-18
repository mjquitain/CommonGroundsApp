import 'package:commongrounds/model/detailed_task.dart';
import 'package:commongrounds/pages/learning_hub_page.dart';
import 'package:commongrounds/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:intl/intl.dart';

class TaskPreviewSheet extends StatelessWidget {
  final DetailedTask task;

  const TaskPreviewSheet({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(task.title, style: AppTypography.heading1),
            const SizedBox(height: 4),
            Text(task.subject, style: AppTypography.heading2.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            Text(task.description, style: AppTypography.bodySmall.copyWith(fontSize: 14)),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text("Due: ${_formatDeadline(task.deadline)}", style: AppTypography.heading1.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
                const Spacer(),
                Icon(Icons.flag, size: 16, color: Colors.redAccent),
                const SizedBox(width: 4),
                Text(task.priority, style: AppTypography.heading1.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navbar,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(initialIndex: 1, taskToOpen: task,),
                    ),
                  );
                },
                child: Text("Open in Learning Hub", style: AppTypography.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDeadline(DateTime date) {
  final formatter = DateFormat('MMM d, h:mm a');
  return formatter.format(date);
}