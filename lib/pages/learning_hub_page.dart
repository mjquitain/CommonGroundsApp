import 'package:commongrounds/widgets/add_new_task.dart';
import 'package:flutter/material.dart';
import 'package:commongrounds/model/detailed_task.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:commongrounds/widgets/task_card_detailed.dart';
import 'package:commongrounds/widgets/filter_dropdowns.dart';
import 'package:commongrounds/widgets/module_card.dart';
import 'package:commongrounds/pages/task_detail_page.dart';
import 'package:commongrounds/data/mock_detailed_tasks.dart';
import 'package:commongrounds/data/mock_modules.dart';
import 'package:commongrounds/widgets/sync_modal.dart';

class LearningHubPage extends StatefulWidget {
  final DetailedTask? selectedTask;

  const LearningHubPage({super.key, this.selectedTask});

  @override
  State<LearningHubPage> createState() => _LearningHubPageState();
}

class _LearningHubPageState extends State<LearningHubPage> {
  final tasks = mockDetailedTasks;
  final modules = mockModules;

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

  void _showTaskModal(DetailedTask  task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: TaskDetailPage(task: task),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final effectiveStatus = (_selectedStatus == null) ? 'All' : _selectedStatus!;
    final effectiveCategory = (_selectedCategory == null) ? 'All' : _selectedCategory!;
    final categoryFiltered = effectiveCategory == 'All'
        ? mockDetailedTasks
        : mockDetailedTasks .where((task) => task.category == effectiveCategory).toList();
    final statusFiltered = effectiveStatus == 'All'
        ? categoryFiltered
        : categoryFiltered.where((task) => task.status == effectiveStatus).toList();
    final sortedTasks = _sortTasks(statusFiltered);
    final showModules = effectiveCategory == 'All' || effectiveCategory == 'Module';
    final shouldHideModulesForStatus = effectiveStatus != 'All';

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

                  const SizedBox(height: 20),
                  if (effectiveCategory == 'Module') ...[
                    if (modules.isEmpty)
                      Center(
                        child: Text(
                          'No modules available.',
                          style: AppTypography.body.copyWith(color: Colors.grey),
                        ),
                      )
                    else
                      Column(
                        children: modules.map((module) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ModuleCard(module: module),
                        ))
                          .toList(),
                      ),
                ] else ...[
                  if (sortedTasks.isEmpty)
                    Center(
                      child: Text(
                        'No tasks in this category.',
                        style: AppTypography.body.copyWith(color: Colors.grey),
                      ),
                    )
                  else
                    Column(
                      children: sortedTasks
                          .map((task) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => _showTaskModal(task),
                          child: TaskCardDetailed(task: task),
                        ),
                      ))
                          .toList(),
                    ),

                  if (showModules && !shouldHideModulesForStatus) ...[
                    Column(
                      children: modules.map((module) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ModuleCard(module: module),
                      )).toList(),
                    ),
                  ],
                ],
              ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}