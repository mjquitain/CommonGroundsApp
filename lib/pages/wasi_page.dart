import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:commongrounds/theme/colors.dart';

enum WasiView { main, chat }

class WasiPage extends StatefulWidget {
  const WasiPage({super.key});

  @override
  State<WasiPage> createState() => _WasiPageState();
}

class _WasiPageState extends State<WasiPage> {
  bool _showChatList = true;
  final TextEditingController _chatController = TextEditingController();

  final List<String> _chats = [
    'Class project idea proposal',
    'Tech Issue Solutions Topics',
  ];

  WasiView currentView = WasiView.main;

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
              // place date at center
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
                  child: currentView == WasiView.main
                      ? _buildChatListSection()
                      : _buildNewChatSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // main chat list
  Widget _buildChatListSection() {
    return Column(
      key: const ValueKey('chatList'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                currentView = WasiView.chat;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              "New Chat",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),

        TextField(
          decoration: InputDecoration(
            hintText: "Search Chat",
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          "Chats",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _chats.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  _chats[index],
                  style: const TextStyle(fontSize: 16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //new chat
  Widget _buildNewChatSection() {
    return Column(
      key: const ValueKey('newChat'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const Center(
          child: Text(
            "Hi! I'm Wasi!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(
                    hintText: "Type your message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        TextButton(
          onPressed: () {
            setState(() {
              currentView = WasiView.main;
            });
          },
          child: const Text("← Back to Chats"),
        ),
      ],
    );
  }
}
