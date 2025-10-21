import 'package:commongrounds/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/widgets/starting_textfield.dart';
import 'package:commongrounds/model/detailed_task.dart';
import 'package:commongrounds/data/mock_detailed_tasks.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  String? selectedSubject;
  String? selectedPriority;
  String? selectedStatus;
  String? selectedCategory;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final subjects = mockDetailedTasks.map((t) => t.subject).toSet().toList();
    final priorities = mockDetailedTasks.map((t) => t.priority).toSet().toList();
    final statuses = mockDetailedTasks.map((t) => t.status).toSet().toList();
    final categories = mockDetailedTasks.map((t) => t.category).toSet().toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add New Task",
                  style: AppTypography.heading1.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 8),

            _buildTextField(
              controller: _titleController,
              label: "Task Title",
              icon: Icons.title,
            ),

            const SizedBox(height: 8),

            _buildDropdown(
              label: "Subject",
              icon: Icons.book,
              value: selectedSubject,
              items: subjects,
              onChanged: (val) => setState(() => selectedSubject = val),
            ),

            const SizedBox(height: 8),

            _buildTextField(
              controller: _descriptionController,
              label: "Description",
              icon: Icons.description,
            ),

            const SizedBox(height: 8),

            _buildTextField(
              controller: _deadlineController,
              label: "Deadline",
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    _deadlineController.text =
                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  });
                }
              },
            ),

            const SizedBox(height: 8),

            _buildDropdown(
              label: "Priority",
              icon: Icons.flag,
              value: selectedPriority,
              items: priorities,
              onChanged: (val) => setState(() => selectedPriority = val),
            ),

            const SizedBox(height: 8),

            _buildDropdown(
              label: "Status",
              icon: Icons.check_circle,
              value: selectedStatus,
              items: statuses,
              onChanged: (val) => setState(() => selectedStatus = val),
            ),

            const SizedBox(height: 8),

            _buildDropdown(
              label: "Category",
              icon: Icons.category,
              value: selectedCategory,
              items: categories,
              onChanged: (val) => setState(() => selectedCategory = val),
            ),

            const SizedBox(height: 16),

            Center(
              child: OutlinedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      selectedSubject == null ||
                      selectedPriority == null ||
                      selectedStatus == null ||
                      selectedCategory == null ||
                      selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill in all fields."),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final newTask = DetailedTask(
                    title: _titleController.text,
                    subject: selectedSubject!,
                    description: _descriptionController.text,
                    deadline: selectedDate!,
                    priority: selectedPriority!,
                    status: selectedStatus!,
                    category: selectedCategory!,
                    progress: 0.0,
                    icon: Icons.task
                  );
                  Navigator.pop(context, newTask);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Add Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: AppTypography.heading2,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          labelText: label,
          labelStyle: AppTypography.bodySmall,
          border: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
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
          hint: Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          items: items.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Row(
                children: [
                  Icon(icon, color: Colors.black54, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e,
                      style: AppTypography.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          dropdownColor: Colors.white,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}