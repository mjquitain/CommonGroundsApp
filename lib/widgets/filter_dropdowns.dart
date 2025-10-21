import 'package:flutter/material.dart';

class StatusFilterDropdown extends StatelessWidget {
  final String? selectedStatus;
  final Function(String?) onChanged;

  const StatusFilterDropdown({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  static const List<String> statusOptions = [
    'All',
    'Overdue',
    'In Progress',
    'Not Started',
    'Completed',
  ];

  static const Map<String, Map<String, dynamic>> statusStyles = {
    'All': {'color': const Color(0xFF616161), 'icon': Icons.filter_list},
    'Overdue': {'color': const Color(0xFFD32F2F), 'icon': Icons.error_outline},
    'In Progress': {'color': const Color(0xFFF57C00), 'icon': Icons.pending},
    'Not Started': {'color': const Color(0xFF1976D2), 'icon': Icons.hourglass_empty},
    'Completed': {'color': const Color(0xFF388E3C), 'icon': Icons.check_circle_outline},
  };

  @override
  Widget build(BuildContext context) {
    final displayValue = selectedStatus ?? 'All';
    return PopupMenuButton<String>(
      color: Colors.white,
      elevation: 6,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      constraints: const BoxConstraints(maxWidth: 220, maxHeight: 300),
      onSelected: (value) {
        onChanged(value == 'All' ? 'All' : value);
      },
      itemBuilder: (context) => statusOptions.map((s) {
        final isSelected = displayValue == s;
        final style = statusStyles[s]!;
        return PopupMenuItem<String>(
          value: s,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: style['color'].withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(style['icon'], color: style['color'], size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? style['color'] : Colors.black,
                  ),
                ),
              ),
              if (isSelected) Icon(Icons.check, size: 18, color: style['color']),
            ],
          ),
        );
      }).toList(),
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
}


class CategoryFilterDropdown extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onChanged;

  const CategoryFilterDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  static const List<String> categories = [
    'All',
    'Homework',
    'Report',
    'Essay',
    'Project',
    'Module',
  ];

  static const Map<String, Map<String, dynamic>> categoryStyles = {
    'All': {'color': const Color(0xFF616161), 'icon': Icons.filter_list},
    'Homework': {'color': const Color(0xFF7E57C2), 'icon': Icons.book},
    'Report': {'color': const Color(0xFF0288D1), 'icon': Icons.description},
    'Essay': {'color': const Color(0xFF009688), 'icon': Icons.edit},
    'Project': {'color': const Color(0xFFFBC02D), 'icon': Icons.engineering},
    'Module': {'color': const Color(0xFF5C6BC0), 'icon': Icons.folder},
  };

  @override
  Widget build(BuildContext context) {
    final displayValue = selectedCategory ?? 'All';
    return PopupMenuButton<String>(
      color: Colors.white,
      elevation: 6,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      constraints: const BoxConstraints(maxWidth: 220, maxHeight: 300),
      onSelected: (value) => onChanged(value == 'All' ? 'All' : value),
      itemBuilder: (context) => categories.map((c) {
        final isSelected = displayValue == c;
        final style = categoryStyles[c]!;
        return PopupMenuItem<String>(
          value: c,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: style['color'].withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(style['icon'], color: style['color'], size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  c,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? style['color'] : Colors.black,
                  ),
                ),
              ),
              if (isSelected) Icon(Icons.check, size: 18, color: style['color']),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
