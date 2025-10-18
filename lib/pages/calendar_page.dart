import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:commongrounds/widgets/task_card_compact.dart';
import 'package:commongrounds/widgets/task_preview_sheet.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:commongrounds/data/mock_detailed_tasks.dart';
import 'package:commongrounds/model/detailed_task.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  late final Map<DateTime, List<DetailedTask>> _events;

  @override
  void initState() {
    super.initState();
    _events = {};

    for (var task in mockDetailedTasks) {
      final taskDate = DateTime(task.deadline.year, task.deadline.month, task.deadline.day);

      if (_events[taskDate] == null) {
        _events[taskDate] = [];
      }
      _events[taskDate]!.add(task);
    }
  }

  List<DetailedTask> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
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
    final tasksForDay = _getEventsForDay(_selectedDay ?? _focusedDay);
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
                child: TableCalendar<DetailedTask>(
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
                  eventLoader: _getEventsForDay,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          bottom: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: events.take(3).map((event) {
                              final task = event;
                              final color = _getStatusColor(task.status);
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

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tasks for the day:',
                style: AppTypography.heading1.copyWith(fontSize: 16),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: tasksForDay.isNotEmpty
                  ? ListView.builder(
                itemCount: tasksForDay.length,
                shrinkWrap: true,
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
                  : Center(
                child: Text(
                  'No tasks for the day',
                  style: AppTypography.heading2.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
