import 'package:flutter/material.dart';
import 'package:commongrounds/model/detailed_task.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:intl/intl.dart';

class TaskCardDetailed extends StatelessWidget {
  final DetailedTask task;

  const TaskCardDetailed({
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.textField.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: _getStatusColor(task.status),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          const SizedBox(height: 4),
                          Text(
                            task.title,
                            style: AppTypography.heading1.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            task.subject,
                            style: AppTypography.heading2.copyWith(
                              fontSize: 13,
                              color: Color(0xFF0D47A1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            task.description,
                            style: AppTypography.heading2.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Due: ${_formatDeadline(task.deadline)}",
                                style: AppTypography.heading2.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: task.progress,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              color: _getStatusColor(task.status),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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