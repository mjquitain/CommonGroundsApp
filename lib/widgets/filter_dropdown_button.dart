import 'package:flutter/material.dart';

class FilterDropdownButton extends StatefulWidget {
  const FilterDropdownButton({super.key});

  @override
  State<FilterDropdownButton> createState() => _FilterDropdownButtonState();
}

class _FilterDropdownButtonState extends State<FilterDropdownButton> {
  String? selectedStatus;
  String? selectedCategory;

  final List<String> status = [
    'All',
    'Overdue',
    'In Progress',
    'Not Started',
    'Completed',
  ];

  final List<String> category = [
    'Homework',
    'Report',
    'Essay',
    'Project',
    'Module',
  ];

  final Map<String, Map<String, dynamic>> statusStyles = {
    'All': {'color': const Color(0xFF616161), 'icon': Icons.filter_list},
    'Overdue': {'color': const Color(0xFFD32F2F), 'icon': Icons.error_outline},
    'In Progress': {'color': const Color(0xFFF57C00), 'icon': Icons.pending},
    'Not Started': {'color': const Color(0xFF1976D2), 'icon': Icons.hourglass_empty},
    'Completed': {'color': const Color(0xFF388E3C), 'icon': Icons.check_circle_outline},
  };

  final Map<String, Map<String, dynamic>> categoryStyles = {
    'Homework': {'color': const Color(0xFF7E57C2), 'icon': Icons.book},
    'Report': {'color': const Color(0xFF0288D1), 'icon': Icons.description},
    'Essay': {'color': const Color(0xFF009688), 'icon': Icons.edit},
    'Project': {'color': const Color(0xFFFBC02D), 'icon': Icons.engineering},
    'Module': {'color': const Color(0xFF5C6BC0), 'icon': Icons.folder},
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      elevation: 6,
      onSelected: (value) {
        setState(() {
          if (status.contains(value)) {
            selectedStatus = value == 'All' ? null : value;
            selectedCategory = value == 'All' ? null : selectedCategory;
          } else {
            selectedCategory = value;
          }
        });
      },
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(maxWidth: 250, maxHeight: 300),
      itemBuilder: (context) {
        return [
          const PopupMenuItem<String>(
            enabled: false,
            child: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          ...status.map((s) => _buildMenuItem(s, statusStyles[s]!)),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            enabled: false,
            child: Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          ...category.map((c) => _buildMenuItem(c, categoryStyles[c]!)),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_alt, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, Map<String, dynamic> style) {
    final isSelected = (status.contains(value) && selectedStatus == value) ||
        (category.contains(value) && selectedCategory == value);

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: style['color'].withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              style['icon'],
              color: style['color'],
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? style['color'] : Colors.black,
              ),
            ),
          ),
          if (isSelected)
            Icon(Icons.check, size: 18, color: style['color']),
        ],
      ),
    );
  }
}