import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';

class SyncModal extends StatelessWidget {
  const SyncModal ({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sync with LMS",
                  style: AppTypography.heading1.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Sync your tasks and modules from the LMS to keep everything updated in your CommonGrounds.",
              style: AppTypography.heading2.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              "Last Synced: September 12, 2025, 12:32",
              style: AppTypography.heading2.copyWith(fontSize: 14, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: null,
              items: [
                DropdownMenuItem(value: "Option 1", child: Text("Option 1"),
                ),
              ],
              onChanged: (value) {Text("Selected: $value");},
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 5,
              children: [
                _checkboxLabel("Sync Tasks"),
                _checkboxLabel("Sync Modules"),
                _checkboxLabel("Auto-sync"),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Sync Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkboxLabel(String label) {
    bool value = false;
    return StatefulBuilder(
      builder: (context, setState) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: (v) => setState(() => value = v ?? false),
          ),
          Text(label),
        ],
      ),
    );
  }
}