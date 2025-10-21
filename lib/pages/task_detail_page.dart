import 'package:flutter/material.dart';
import 'package:commongrounds/model/detailed_task.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends StatelessWidget {
  final DetailedTask task;

  const TaskDetailPage({
    super.key,
    required this.task,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'overdue':
        return Colors.redAccent;
      case 'in progress':
        return Colors.orangeAccent;
      case 'not started':
        return Colors.lightBlueAccent;
      case 'completed':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(task.title, style: AppTypography.heading1),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(task.icon, color: AppColors.icon, size: 28),
                  const SizedBox(width: 10),
                  Text(task.subject, style: AppTypography.heading2.copyWith(fontSize: 18, color: Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(task.status).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.status.toUpperCase(),
                      style: AppTypography.heading2.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text("Description", style: AppTypography.body.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(task.description, style: AppTypography.bodySmall.copyWith(fontSize: 16)),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text("Deadline: ${_formatDeadline(task.deadline)}", style: AppTypography.caption.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.flag, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text("Priority: ${task.priority}", style: AppTypography.caption.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),

              Text("Progress", style: AppTypography.heading1.copyWith(fontSize: 18)),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: task.progress,
                color: AppColors.text,
                backgroundColor: AppColors.textField.withOpacity(0.2),
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 10),
              Text(
                "${(task.progress * 100).toInt()}% completed",
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDeadline(DateTime date) {
  final formatter = DateFormat('MMM d, h:mm a');
  return formatter.format(date);
}