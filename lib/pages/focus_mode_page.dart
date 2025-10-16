import 'package:flutter/material.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:intl/intl.dart';

class FocusModePage extends StatefulWidget {
  const FocusModePage({super.key});

  @override
  State<FocusModePage> createState() => _FocusModePageState();
}

class _FocusModePageState extends State<FocusModePage> {
  Duration focusDuration = const Duration(minutes: 25);
  Duration shortBreakDuration = const Duration(minutes: 5);
  Duration longBreakDuration = const Duration(minutes: 15);

  bool isRunning = false;
  late Duration currentTime;
  late String currentMode; // "Focus", "Short Break", "Long Break"

  @override
  void initState() {
    super.initState();
    currentMode = "Focus Mode";
    currentTime = focusDuration;
  }

  void startTimer() {
    setState(() {
      isRunning = true;
      // TODO: implement actual timer logic in step 2
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
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
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMM d, y').format(now);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // FOCUS
            _buildTimerSection("Focus Mode", focusDuration),
            const SizedBox(height: 20),

            // SHORT BREAK
            _buildTimerSection("Short Break", shortBreakDuration),
            const SizedBox(height: 20),

            // LONG BREAK
            _buildTimerSection("Long Break", longBreakDuration),
            const SizedBox(height: 30),

            // HISTORY + START BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Show history modal
                    },
                    child: const Text("History"),
                  ),
                ),
                const SizedBox(width: 20), // 👈 closer spacing
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: isRunning ? stopTimer : startTimer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(isRunning ? "Stop" : "Start"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
            // show a dialog to adjust minutes
            int? newMinutes = await _showAdjustDialog(label, duration.inMinutes);
            if (newMinutes != null) {
              adjustTime(label, newMinutes);
            }
          },
          child: Center(
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
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
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
}