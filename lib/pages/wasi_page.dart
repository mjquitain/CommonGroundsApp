import 'package:commongrounds/theme/typography.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: currentView == WasiView.chat ? 0 : 30, vertical: currentView == WasiView.chat ? 0 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
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
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            child: Text(
              "New Chat",
              style: AppTypography.button.copyWith(
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        TextField(
          decoration: InputDecoration(
            hintText: "Search Chat",
            filled: true,
            fillColor: AppColors.textField.withOpacity(0.1),
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
                  color: AppColors.textField.withOpacity(0.1),
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

  Widget _buildNewChatSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        key: const ValueKey('newChat'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      currentView = WasiView.main;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ),
                  iconSize: 28,
                  splashRadius: 28,
                ),
              ),
            ],
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.navbar.withOpacity(0.3),
                      child: Icon(
                        Icons.flutter_dash,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.circle, size: 8, color: Colors.green),
                          SizedBox(width: 6),
                          Text(
                            "Hi, I'm Wasi!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file_outlined),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          decoration: InputDecoration(
                            hintText: "Type your message...",
                            filled: false,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
