import 'package:commongrounds/model/detailed_task.dart';
import 'package:commongrounds/pages/task_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:commongrounds/pages/dashboard_page.dart';
import 'package:commongrounds/pages/learning_hub_page.dart';
import 'package:commongrounds/pages/calendar_page.dart';
import 'package:commongrounds/pages/focus_mode_page.dart';
import 'package:commongrounds/pages/wasi_page.dart';
import 'package:commongrounds/widgets/top_navbar.dart';
import 'package:commongrounds/widgets/bottom_navbar.dart';
import 'package:commongrounds/pages/sign_in_page.dart';


class MainPage extends StatefulWidget {
  final int initialIndex;
  final DetailedTask? taskToOpen;
  const MainPage({super.key, this.initialIndex = 0, this.taskToOpen,});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;
  int _previousIndex = 0;
  DetailedTask? _taskToOpenInitially;

  final List<String> _pageTitles = const [
    "Dashboard",
    "Learning Hub",
    "Calendar",
    "Focus Mode",
    "Wasi",
  ];

  List<Widget> _buildPages() {
    return [
    const DashboardPage(),
    LearningHubPage(selectedTask: _currentIndex == 1 ? _taskToOpenInitially : null),
    const CalendarPage(),
    const FocusModePage(),
    const WasiPage(),
  ];
}

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _previousIndex = widget.initialIndex;
    _taskToOpenInitially = widget.taskToOpen;
  }

  void _onNavTap(int index) {
    if (index != _currentIndex) {
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex = index;
        if (_taskToOpenInitially != null) {
          _taskToOpenInitially = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = _buildPages();

    return Scaffold(
      appBar: TopNavbar(
        pageTitle: _pageTitles[_currentIndex],
        onProfileTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        },
        onNotificationTap: () {
        },
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final isForward = _currentIndex > _previousIndex;
          final offsetBegin = isForward ? const Offset(0.2, 0.0) : const Offset(-0.2, 0.0);

          return SlideTransition(
            position: Tween<Offset>(
              begin: offsetBegin,
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}