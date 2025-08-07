import 'package:flutter/material.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/features/auth/login_screen.dart';
import 'package:onbook_app/features/approot/app_root.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();

    // ✅ Add delay to hold splash at least 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isReady = true;
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // 🔒 Hold splash until both ready AND auth done
    if (!_isReady || authProvider.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OnBook Solutions',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Service. Support. Speed',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ✅ Navigate only after both auth + splash delay are done
    if (authProvider.user == null || authProvider.userData == null) {
      return const LoginScreen();
    } else {
      return const AppRoot();
    }
  }
}
