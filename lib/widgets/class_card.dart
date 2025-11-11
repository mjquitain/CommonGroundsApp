import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:commongrounds/model/class.dart';
import 'package:intl/intl.dart';

class ClassCard extends StatelessWidget {
  final ClassModel classData;

  const ClassCard({
    super.key,
    required this.classData,
  });

  int _dayToWeekday(String day) {
    switch (day.toLowerCase()) {
      case 'monday': return DateTime.monday;
      case 'tuesday': return DateTime.tuesday;
      case 'wednesday': return DateTime.wednesday;
      case 'thursday': return DateTime.thursday;
      case 'friday': return DateTime.friday;
      case 'saturday': return DateTime.saturday;
      case 'sunday': return DateTime.sunday;
      default: return 0;
    }
  }

  String _getStatus(ClassModel data) {
    final now = DateTime.now();

    final parts = data.time.split(' - ');
    if (parts.length != 2) return 'Error';

    final startTimeStr = parts[0];
    final startTimeFormat = DateFormat('h:mm a');
    final startTime = startTimeFormat.parse(startTimeStr);

    final endTimeStr = parts[1];
    final endTimeFormat = DateFormat('h:mm a');
    final endTime = endTimeFormat.parse(endTimeStr);

    final scheduledWeekday = _dayToWeekday(data.day);
    if (scheduledWeekday == 0) return 'Unknown';

    int daysDifference = scheduledWeekday - now.weekday;
    DateTime classDate = now.add(Duration(days: daysDifference));

    DateTime classStart = DateTime(
      classDate.year,
      classDate.month,
      classDate.day,
      startTime.hour,
      startTime.minute,
    );

    DateTime classEnd = DateTime(
      classDate.year,
      classDate.month,
      classDate.day,
      endTime.hour,
      endTime.minute,
    );

    if (now.isAfter(classStart) && now.isBefore(classEnd)) {
      return 'Ongoing';
    } else if (now.isBefore(classStart)) {
      return 'Upcoming';
    } else {
      return 'Finished';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return Colors.yellow;
      case 'upcoming':
        return Colors.lightBlueAccent;
      case 'finished':
        return Colors.greenAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _getStatus(classData);
    final statusColor = _getStatusColor(status);
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
                color: statusColor,
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
                        classData.icon,
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
                            classData.subject,
                            style: AppTypography.heading1.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                classData.day,
                                style: AppTypography.heading2.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D47A1),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 1.2,
                                height: 16,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  classData.instructor,
                                  style: AppTypography.heading2.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D47A1),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Time: ${classData.time}',
                                  style: AppTypography.heading2.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status.toUpperCase(),
                                    style: AppTypography.heading2.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
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
