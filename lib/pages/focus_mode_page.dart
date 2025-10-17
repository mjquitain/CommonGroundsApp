import 'dart:async';
import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:intl/intl.dart';

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
          showExitButton = true;
        }
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resumeTimer() {
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (currentTime.inSeconds > 0) {
          currentTime -= const Duration(seconds: 1);
        } else {
          t.cancel();
          isRunning = false;
          showExitButton = true;
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      showExitButton = true;
    });
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      showExitButton = false;
      currentMode = "Focus Mode";
      currentTime = focusDuration;
      currentView = FocusModeView.main;
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

  void adjustTime(String mode, int minutes) {
    setState(() {
      if (mode == "Focus Mode") {
        focusDuration = Duration(minutes: minutes);
        if (currentMode == "Focus Mode") currentTime = focusDuration;
      } else if (mode == "Short Break") {
        shortBreakDuration = Duration(minutes: minutes);
        if (currentMode == "Short Break") currentTime = shortBreakDuration;
      } else {
        longBreakDuration = Duration(minutes: minutes);
        if (currentMode == "Long Break") currentTime = longBreakDuration;
      }
    });
  }

  String formatTime(Duration duration) {
    String minutes =
    duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void showSaveSessionDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Name of Session"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter session name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // dialog closes on active timer
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String sessionName = controller.text.trim();
                if (sessionName.isEmpty) {
                  sessionName = "Focus Mode Session #$sessionCounter";
                }

                final String dateString =
                DateFormat('MMM d, yyyy').format(DateTime.now());

                setState(() {
                  sessionHistory.add({
                    'name': sessionName,
                    'date': dateString,
                  });
                  sessionCounter++;
                });

                Navigator.pop(context);
                resetTimer();
              },
              child: const Text("Save"),
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
        _buildTimerSection("Focus Mode", focusDuration),
        const SizedBox(height: 20),
        _buildTimerSection("Short Break", shortBreakDuration),
        const SizedBox(height: 20),
        _buildTimerSection("Long Break", longBreakDuration),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    currentView = FocusModeView.history;
                  });
                },
                child: const Text("History"),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: startTimer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Start"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerView() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _modeButton("Focus Mode"),
                _modeButton("Short Break"),
                _modeButton("Long Break"),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              currentMode,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              formatTime(currentTime),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: stopTimer,
                  child: const Text("Stop"),
                ),
                const SizedBox(width: 15),
                if (isRunning)
                  ElevatedButton(
                    onPressed: pauseTimer,
                    child: const Text("Pause"),
                  )
                else
                  ElevatedButton(
                    onPressed: resumeTimer,
                    child: const Text("Resume"),
                  ),
              ],
            ),
            if (showExitButton) ...[
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: showSaveSessionDialog,
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
              SizedBox(width: 5),
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

  Widget _buildTimerSection(String label, Duration duration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            int? newMinutes = await _showAdjustDialog(label, duration.inMinutes);
            if (newMinutes != null) {
              adjustTime(label, newMinutes);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "${duration.inMinutes.toString().padLeft(2, '0')}:00",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
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
          color: active ? AppColors.navbar : Colors.grey.shade300,
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

  Future<int?> _showAdjustDialog(String mode, int currentMinutes) async {
    final controller = TextEditingController(text: currentMinutes.toString());
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set $mode Minutes"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Minutes",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value != null && value > 0) {
                  Navigator.pop(context, value);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMM d, y').format(now);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
