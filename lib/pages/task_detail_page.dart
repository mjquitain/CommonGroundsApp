import 'package:flutter/material.dart';
import 'package:commongrounds/model/detailed_task.dart';
import 'package:commongrounds/model/task_step.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends StatelessWidget {
  final DetailedTask task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(double)? onProgressUpdated;

  const TaskDetailPage({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
    this.onProgressUpdated,
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

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high priority':
        return Colors.redAccent;
      case 'medium priority':
        return Colors.orangeAccent;
      case 'low priority':
        return Colors.lightGreenAccent;
      default:
        return Colors.grey;
    }
  }

  const TaskDetailPage.readOnly({
    super.key,
    required this.task,
  })  : onEdit = null,
        onDelete = null,
        onProgressUpdated = null;

  Widget _buildDescriptionContent(DetailedTask task) {
    if (task.simpleDescription != null) {
      return Text(
        task.simpleDescription!,
        style: AppTypography.bodySmall.copyWith(fontSize: 16),
      );
    } else if (task.detailedSteps != null && task.detailedSteps!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: task.detailedSteps!.map((TaskStep step) {
          final identifier = step.step != null
              ? 'Step ${step.step}'
              : (step.phase ?? 'Item');

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.name != null
                      ? "$identifier: ${step.name!}"
                      : identifier,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  step.details,
                  style: AppTypography.bodySmall.copyWith(fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } else {
      return Text(
        "No description provided for this task.",
        style: AppTypography.bodySmall.copyWith(fontSize: 16, fontStyle: FontStyle.italic),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDelete,
              ),
            ],
          )
        ],
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15 ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: AppTypography.heading1),
              Text(task.subject, style: AppTypography.heading2.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.remove_circle_outline, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text("Status: ", style: AppTypography.caption.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
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
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.flag, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text("Priority: ", style: AppTypography.caption.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.priority).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: AppTypography.heading2.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text("Deadline: ${_formatDeadline(task.deadline)}", style: AppTypography.caption.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Progress", style: AppTypography.heading1.copyWith(fontSize: 18)),
                  Text(
                    "${(task.progress * 100).toInt()}% completed",
                    style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: task.progress,
                color: AppColors.text,
                backgroundColor: AppColors.textField.withOpacity(0.2),
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 15),
              Text("Description", style: AppTypography.body.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDescriptionContent(task),
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