import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:commongrounds/widgets/task_card_compact.dart';
import 'package:commongrounds/widgets/task_preview_sheet.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:commongrounds/data/mock_detailed_tasks.dart';
import 'package:commongrounds/model/detailed_task.dart';
import 'package:commongrounds/data/mock_classes.dart';
import 'package:commongrounds/model/class.dart';
import 'package:commongrounds/widgets/class_card.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  late final Map<DateTime, List<DetailedTask>> _taskEvents;
  late final Map<DateTime, List<ClassModel>> _classEvents;

  @override
  void initState() {
    super.initState();
    _taskEvents = {};
    _classEvents = {};

    for (var task in mockDetailedTasks) {
      final taskDate = DateTime(task.deadline.year, task.deadline.month, task.deadline.day);

      if (_taskEvents[taskDate] == null) {
        _taskEvents[taskDate] = [];
      }
      _taskEvents[taskDate]!.add(task);
    }

    final now = DateTime.now();
    final startYear = now.year - 1;
    final endYear = now.year + 1;
    final classStartDate = DateTime(now.year, 08, 18);
    final classEndDate = DateTime(now.year, 11, 28);

    for (int year = startYear; year <= endYear; year++) {
      for (int month = 1; month <= 12; month++) {
        for (int day = 1; day <= 31; day++) {
          try {
            final date = DateTime(year, month, day);
            final dayName = DateFormat('EEEE').format(date);

            for (var classItem in mockClasses) {
              if (classItem.day.toLowerCase() == dayName.toLowerCase()) {
                final classDate = DateTime(date.year, date.month, date.day);
                if (classDate.isAfter(classEndDate)) {
                  continue;
                }
                if (classDate.isBefore(classStartDate)) {
                  continue;
                }
                if (_classEvents[classDate] == null) {
                  _classEvents[classDate] = [];
                }
                if (!_classEvents[classDate]!.contains(classItem)) {
                  _classEvents[classDate]!.add(classItem);
                }
              }
            }
          } catch (_) {
          }
        }
      }
    }
  }

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

  List<DetailedTask> _getTaskEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _taskEvents[normalizedDay] ?? [];
  }

  List<ClassModel> _getClassesForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _classEvents[normalizedDay] ?? [];
  }

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
    final displayDay = _selectedDay ?? _focusedDay;
    final tasksForDay = _getTaskEventsForDay(displayDay);
    final classesForDay = _getClassesForDay(displayDay);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CupertinoSlidingSegmentedControl<CalendarFormat>(
                  backgroundColor: AppColors.navbar.withOpacity(0.3),
                  thumbColor: AppColors.navbar,
                  groupValue: _calendarFormat,
                  children: {
                    CalendarFormat.month: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        'Month View',
                        style: TextStyle(
                          color: _calendarFormat == CalendarFormat.month
                              ? AppColors.text
                              : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CalendarFormat.week: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        'Week View',
                        style: TextStyle(
                          color: _calendarFormat == CalendarFormat.week
                              ? AppColors.text
                              : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  },
                  onValueChanged: (CalendarFormat? value) {
                    if (value != null) {
                      setState(() {
                        _calendarFormat = value;
                      });
                    }
                  },
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: AppColors.navbar.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black45,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TableCalendar<dynamic>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {_calendarFormat = format;});
                  },
                  eventLoader: (day) => _getTaskEventsForDay(day).cast<dynamic>() + _getClassesForDay(day),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          bottom: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: events.take(3).map((event) {
                              Color color;
                              if (event is DetailedTask) {
                                color = _getStatusColor(event.status);
                              } else {
                                color = Colors.purple.shade700;
                              }
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: true,
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tasks for ${DateFormat('EEEE, MMM d').format(displayDay)}:',
                      style: AppTypography.heading1.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    if (tasksForDay.isNotEmpty)
                      ListView.builder(
                        itemCount: tasksForDay.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final task = tasksForDay[index];
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
                      )
                    else
                      Center(
                        child: Text(
                          'No tasks scheduled.',
                          style: AppTypography.heading2.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                        ),
                      ),

                    const SizedBox(height: 16),

                    Text(
                      'Classes for ${DateFormat('EEEE, MMM d').format(displayDay)}:',
                      style: AppTypography.heading1.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    if (classesForDay.isNotEmpty)
                      ListView.builder(
                        itemCount: classesForDay.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final classData = classesForDay[index];
                          return ClassCard(classData: classData);
                        },
                      )
                    else
                      Center(
                        child: Text(
                          'No classes scheduled.',
                          style: AppTypography.heading2.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
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
