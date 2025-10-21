import 'package:flutter/material.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/model/detailed_task.dart';
import 'package:intl/intl.dart';

class TaskCardCompact extends StatelessWidget {
  final DetailedTask task;

  const TaskCardCompact({
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
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        task.icon,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            task.title,
                            style: AppTypography.heading1.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text(
                            task.subject,
                            style: AppTypography.heading2.copyWith(
                              fontSize: 13,
                              color: Color(0xFF0D47A1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Due: ${_formatDeadline(task.deadline)}",
                                  style: AppTypography.heading2.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
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
                        ],
                      ),
                    ),
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