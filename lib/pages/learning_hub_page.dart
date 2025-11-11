import 'package:commongrounds/widgets/add_new_task.dart';
import 'package:flutter/material.dart';
import 'package:commongrounds/model/detailed_task.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:commongrounds/widgets/task_card_detailed.dart';
import 'package:commongrounds/widgets/filter_dropdowns.dart';
import 'package:commongrounds/pages/task_detail_page.dart';
import 'package:commongrounds/data/mock_detailed_tasks.dart';
import 'package:commongrounds/widgets/sync_modal.dart';

class LearningHubPage extends StatefulWidget {
  final DetailedTask? selectedTask;

  const LearningHubPage({super.key, this.selectedTask});

  @override
  State<LearningHubPage> createState() => _LearningHubPageState();
}

class _LearningHubPageState extends State<LearningHubPage> {
  final tasks = mockDetailedTasks;

  String? _selectedStatus = 'All';
  String? _selectedCategory = 'All';

  final Map<String, int> _priorityRank = {
    'High': 1,
    'Medium': 2,
    'Low': 3,
  };

  List<DetailedTask> _sortTasks(List<DetailedTask> tasks) {
    final sorted = [...tasks];
    sorted.sort((a, b) {
      final priorityCompare = (_priorityRank[a.priority] ?? 4)
          .compareTo(_priorityRank[b.priority] ?? 4);
      if (priorityCompare != 0) return priorityCompare;

      return a.deadline.compareTo(b.deadline);
    });
    return sorted;
  }

  void _onStatusSelected(String? status) {
    setState(() => _selectedStatus = status);
  }

  void _onCategorySelected(String? newCategory) {
    setState(() {
      _selectedCategory = newCategory ?? 'All';
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.selectedTask != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTaskModal(widget.selectedTask!);
      });
    }
  }

  void _showTaskModal(DetailedTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: TaskDetailPage(
            task: task,
            onEdit: () => _editTask(context, task, mockDetailedTasks.indexOf(task)),
            onDelete: () => _deleteTask(task),
            onProgressUpdated: (newProgress) {
              setState(() {
                task = task.copyWith(progress: newProgress);
              });
            },
          ),
        ),
      ),
    );
  }

  void _deleteTask(DetailedTask task) {
    setState(() {
      mockDetailedTasks.remove(task);
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task deleted')),
    );
  }

  void _editTask(BuildContext context, DetailedTask task, int index) {
    final titleController = TextEditingController(text: task.title);
    final subjectController = TextEditingController(text: task.subject);
    final descriptionController = TextEditingController(text: task.simpleDescription);
    final statuses = ['Not Started', 'In Progress', 'Completed', 'Overdue'];

    DateTime selectedDeadline = task.deadline;
    String selectedStatus = task.status;
    double progress = task.progress;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF8F9FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Edit Task',
                style: AppTypography.heading1.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Deadline:", style: AppTypography.bodySmall),
                          TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDeadline,
                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDeadline = picked;
                                });
                              }
                            },
                            child: Text(
                              "${selectedDeadline.toLocal()}".split(' ')[0],
                              style: AppTypography.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildDropdown(
                      label: "Status",
                      value: selectedStatus,
                      items: statuses,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Progress"),
                          Slider(
                            value: progress,
                            onChanged: (val) {
                              setState(() {
                                progress = val;
                              });
                            },
                            min: 0,
                            max: 1,
                            divisions: 10,
                            label: "${(progress * 100).round()}%",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    this.setState(() {
                      final updatedTask = DetailedTask(
                        title: titleController.text,
                        subject: subjectController.text,
                        simpleDescription: descriptionController.text,
                        deadline: selectedDeadline,
                        priority: task.priority,
                        status: selectedStatus,
                        progress: progress,
                        icon: task.icon,
                        category: task.category,
                      );
                      if (index >= 0 && index < mockDetailedTasks.length) {
                        mockDetailedTasks[index] = updatedTask;
                      }
                      if (index >= 0 && index < tasks.length) {
                        tasks[index] = updatedTask;
                      }
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task updated successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(label, style: AppTypography.bodySmall),
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: AppTypography.bodySmall),
          ))
              .toList(),
          onChanged: onChanged,
          isExpanded: true,
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStatus = _selectedStatus ?? 'All';
    final effectiveCategory = _selectedCategory ?? 'All';

    final categoryFiltered = effectiveCategory == 'All'
        ? mockDetailedTasks
        : mockDetailedTasks.where((task) => task.category == effectiveCategory).toList();
    final statusFiltered = effectiveStatus == 'All'
        ? categoryFiltered
        : categoryFiltered.where((task) => task.status == effectiveStatus).toList();

    final sortedTasks = _sortTasks(statusFiltered);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          StatusFilterDropdown(
                            selectedStatus: _selectedStatus,
                            onChanged: _onStatusSelected,
                          ),
                          const SizedBox(width: 10),
                          CategoryFilterDropdown(
                            selectedCategory: _selectedCategory,
                            onChanged: _onCategorySelected,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const SyncModal(),
                              );
                            },
                            icon: const Icon(Icons.sync_rounded),
                            tooltip: 'Sync LMS',
                            color: AppColors.text,
                          ),
                          IconButton(
                            onPressed: () async {
                              final newTask = await showDialog<DetailedTask>(
                                context: context,
                                builder: (context) => const AddNewTask(),
                              );

                              if (newTask != null) {
                                setState(() {
                                  mockDetailedTasks.add(newTask);
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                            tooltip: 'Add Task',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (sortedTasks.isEmpty)
                    Center(
                      child: Text(
                        'No tasks in this category.',
                        style: AppTypography.body.copyWith(color: Colors.grey),
                      ),
                    )
                  else
                    Column(
                      children: sortedTasks.map((task) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () => _showTaskModal(task),
                            child: TaskCardDetailed(task: task),
                          ),
                        );
                      }).toList(),
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
