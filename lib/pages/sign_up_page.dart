import 'package:flutter/material.dart';
import 'package:commongrounds/widgets/starting_button.dart';
import 'package:commongrounds/theme/colors.dart';
import 'package:commongrounds/theme/typography.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:commongrounds/widgets/starting_textfield.dart';
import 'package:commongrounds/pages/main_page.dart' as mainpage;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _goToMainPage() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const mainpage.MainPage(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 250,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.navbar.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: -150,
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.navbar.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              width: 250,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.navbar.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            right: -140,
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.navbar.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Transform.translate(
                      offset: const Offset(0, -60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Center(
                              child: Image.asset(
                                'assets/group_main.png',
                                height: 80,
                              ),
                            ),
                          ),
                          Text(
                            'Welcome Back!',
                            style: AppTypography.heading1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Focus. Plan. Achieve',
                              textAlign: TextAlign.center,
                              style: AppTypography.heading2,
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomTextField(
                            label: 'Enter your full name',
                            width: 350,
                          ),
                          CustomTextField(
                            label: 'Enter your email',
                            width: 350,
                          ),
                          CustomTextField(
                            label: 'Enter password',
                            obscureText: true,
                            width: 350,
                          ),
                          CustomTextField(
                            label: 'Confirm password',
                            obscureText: true,
                            width: 350,
                          ),
                          const SizedBox(height: 20),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: CustomButton(
                              text: 'Sign Up',
                              onPressed: _goToMainPage,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}