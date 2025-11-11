import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';

enum FocusModeView { main, timer, history }

class FocusModePage extends StatefulWidget {
  const FocusModePage({super.key});

  @override
  State<FocusModePage> createState() => _FocusModePageState();
}

class _FocusModePageState extends State<FocusModePage>
    with SingleTickerProviderStateMixin {
  Duration focusDuration = const Duration(minutes: 25);
  Duration shortBreakDuration = const Duration(minutes: 5);
  Duration longBreakDuration = const Duration(minutes: 15);

  late Duration currentTime;
  late String currentMode;
  bool isRunning = false;
  bool showExitButton = false;

  Timer? timer;
  FocusModeView currentView = FocusModeView.main;

  List<Map<String, String>> sessionHistory = [];
  int sessionCounter = 1;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    currentMode = "Focus Mode";
    currentTime = focusDuration;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      currentView = FocusModeView.timer;
      isRunning = true;
      showExitButton = false;
    });
    _animationController.forward(from: 0);
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (currentTime.inSeconds > 0) {
          currentTime -= const Duration(seconds: 1);
        } else {
          t.cancel();
          isRunning = false;
          logSession();
          nextSession();
        }
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      showExitButton = true;
    });
  }

  void resumeTimer() {
    setState(() {
      isRunning = true;
      showExitButton = false;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (currentTime.inSeconds > 0) {
          currentTime -= const Duration(seconds: 1);
        } else {
          t.cancel();
          isRunning = false;
          logSession();
          nextSession();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Stop Timer"),
        content: const Text("Do you want to go back to the timer selection screen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetTimer();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void resetTimer({bool clearView = true}) {
    setState(() {
      isRunning = false;
      showExitButton = false;
      currentMode = "Focus Mode";
      currentTime = focusDuration;
      if (clearView) currentView = FocusModeView.main;
    });
  }

  void switchMode(String mode) {
    setState(() {
      currentMode = mode;
      if (mode == "Focus Mode") currentTime = focusDuration;
      if (mode == "Short Break") currentTime = shortBreakDuration;
      if (mode == "Long Break") currentTime = longBreakDuration;
    });
  }

  void adjustTime(String mode, int minutes, int seconds) {
    setState(() {
      Duration newDuration = Duration(minutes: minutes, seconds: seconds);
      if (mode == "Focus Mode") {
        focusDuration = newDuration;
        if (currentMode == "Focus Mode") currentTime = focusDuration;
      } else if (mode == "Short Break") {
        shortBreakDuration = newDuration;
        if (currentMode == "Short Break") currentTime = shortBreakDuration;
      } else {
        longBreakDuration = newDuration;
        if (currentMode == "Long Break") currentTime = longBreakDuration;
      }
    });
  }

  void logSession({String? name}) {
    final String dateString =
    DateFormat('M/d, hh:mm a').format(DateTime.now());

    setState(() {
      sessionHistory.add({
        'name': name ?? '$currentMode Session #$sessionCounter',
        'date': dateString,
      });
      if (currentMode == "Focus Mode") {
        sessionCounter++;
      }
    });
  }

  void nextSession() {
    if (currentMode == "Focus Mode") {
      if (sessionCounter % 4 == 0) {
        switchMode("Long Break");
      } else {
        switchMode("Short Break");
      }
    } else {
      switchMode("Focus Mode");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Starting next session: $currentMode"),
        duration: const Duration(seconds: 2),
      ),
    );
      startTimer();
  }

  String formatTime(Duration duration) {
    String minutes =
    duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void showSaveSessionDialog({
    required VoidCallback onSaved,
    required VoidCallback onExited,
    bool isInterrupted = false,
  }) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Session Finished"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Would you like to save this session?"),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Optional: Enter session name",
                  filled: true,
                  fillColor: AppColors.textField.withOpacity(0.1),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    resetTimer();
                  },
                  child: const Text("Exit Without Saving"),
                ),
                TextButton(
                  onPressed: () {
                    String sessionName = controller.text.trim();
                    if (sessionName.isEmpty) {
                      sessionName = "$currentMode Session #$sessionCounter";
                    }
                    logSession(name: sessionName);
                    Navigator.pop(context);
                    resetTimer();
                  },
                  child: const Text("Save Session"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTimerSection("Focus Mode", focusDuration, Icons.timer),
        const SizedBox(height: 20),
        _buildTimerSection("Short Break", shortBreakDuration, Icons.coffee),
        const SizedBox(height: 20),
        _buildTimerSection("Long Break", longBreakDuration, Icons.nightlight_outlined),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    currentView = FocusModeView.history;
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.navbar.withOpacity(0.3),
                  foregroundColor: AppColors.text,
                ),
                child: const Text("History"),
              ),
            ),
            const SizedBox(width: 25),
            SizedBox(
              width: 150,
              child: OutlinedButton(
                onPressed: startTimer,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.navbar.withOpacity(0.3),
                  foregroundColor: AppColors.text,
                ),
                child: Text("Start"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerView() {
    double progress = 1 -
        (currentTime.inSeconds /
            (currentMode == "Focus Mode"
                ? focusDuration.inSeconds
                : currentMode == "Short Break"
                ? shortBreakDuration.inSeconds
                : longBreakDuration.inSeconds));

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _modeButton("Focus Mode"),
                _modeButton("Short Break"),
                _modeButton("Long Break"),
              ],
            ),
            const SizedBox(height: 45),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, _) => CircularProgressIndicator(
                      value: value.clamp(0.0, 1.0),
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        currentMode == "Focus Mode"
                            ? AppColors.navbar
                            : currentMode == "Short Break"
                            ? Colors.green
                            : Colors.blue,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      currentMode,
                      style: AppTypography.heading1.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatTime(currentTime),
                      style: AppTypography.heading2.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: stopTimer,
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.text),
                  child: const Text("Stop"),
                ),
                const SizedBox(width: 15),
                if (isRunning)
                  OutlinedButton(
                    onPressed: pauseTimer,
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.text),
                    child: const Text("Pause"),
                  )
                else
                  OutlinedButton(
                    onPressed: resumeTimer,
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.text),
                    child: const Text("Resume"),
                  ),
              ],
            ),
            if (showExitButton) ...[
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => showSaveSessionDialog(
                  onSaved: () => resetTimer(clearView: true),
                  onExited: () => resetTimer(clearView: true),
                  isInterrupted: true,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red),
                child: const Text("Exit"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              currentView = FocusModeView.main;
            });
          },
          child: const Row(
            children: [
              Icon(Icons.arrow_back, size: 20),
              SizedBox(width: 10),
              Text(
                "Focus Mode",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: sessionHistory.isEmpty
              ? const Center(
            child: Text(
              "No sessions saved yet.",
              style: TextStyle(fontSize: 16),
            ),
          )
              : ListView.builder(
            itemCount: sessionHistory.length,
            itemBuilder: (context, index) {
              final session = sessionHistory[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      session['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      session['date'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimerSection(String label, Duration duration, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.icon,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTypography.heading1,
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            int currentMinutes = duration.inMinutes;
            int currentSeconds = duration.inSeconds.remainder(60);

            Map<String, int>? newDuration = await _showAdjustDialog(label, currentMinutes, currentSeconds);
            if (newDuration != null) {
              adjustTime(label, newDuration['minutes']!, newDuration['seconds']!);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.textField.withOpacity(0.1),
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              formatTime(duration),
              textAlign: TextAlign.center,
              style: AppTypography.heading2.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _modeButton(String mode) {
    final bool active = currentMode == mode;
    return GestureDetector(
      onTap: () => switchMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.navbar : AppColors.textField.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          mode,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<Map<String, int>?> _showAdjustDialog(String mode, int currentMinutes, int currentSeconds) async {
    final minController = TextEditingController(text: currentMinutes.toString());
    final secController = TextEditingController(text: currentSeconds.toString().padLeft(2, '0'));

    return showDialog<Map<String, int>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set $mode Duration", style: AppTypography.heading1.copyWith(fontSize: 23, letterSpacing: 0.5)),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: minController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Minutes",
                    labelStyle: AppTypography.heading2.copyWith(fontSize: 18),
                    filled: true,
                    fillColor: AppColors.textField.withOpacity(0.1),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: secController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Seconds",
                    labelStyle: AppTypography.heading2.copyWith(fontSize: 18),
                    filled: true,
                    fillColor: AppColors.textField.withOpacity(0.1),
                    border: const OutlineInputBorder(),
                    hintText: '00-59',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: AppColors.text),
              child: const Text("Cancel"),
            ),
            OutlinedButton(
              onPressed: () {
                final newMinutes = int.tryParse(minController.text.trim());
                final newSeconds = int.tryParse(secController.text.trim());

                if (newMinutes != null && newSeconds != null && newMinutes >= 0 && newSeconds >= 0 && newSeconds < 60) {
                  if (newMinutes + newSeconds > 0) {
                    Navigator.pop(context, {'minutes': newMinutes, 'seconds': newSeconds});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Duration must be greater than 0.")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid input. Seconds must be 0-59.")),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.navbar.withOpacity(0.3),
                foregroundColor: AppColors.text,
              ),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: currentView == FocusModeView.main
                      ? _buildMainView()
                      : currentView == FocusModeView.timer
                      ? _buildTimerView()
                      : _buildHistoryView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
