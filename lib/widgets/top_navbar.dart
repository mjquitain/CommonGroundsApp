import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';

class TopNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  const TopNavbar({
    super.key,
    required this.pageTitle,
    this.onProfileTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.navbar,
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          pageTitle,
          style: AppTypography.heading1.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        Padding(padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.icon),
                onPressed: onNotificationTap,
              ),
              IconButton(
                icon: const Icon(Icons.person_outlined, color: AppColors.icon),
                onPressed: onProfileTap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}