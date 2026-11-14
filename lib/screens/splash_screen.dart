import 'package:flutter/material.dart';

import '../core/app_assets.dart';
import '../core/prefs.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        Prefs.onboardingDone
            ? HomeScreen.routeName
            : OnboardingScreen.routeName,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.splashBg, fit: BoxFit.cover),
          // Mosque outline at the top
          Positioned(
            top: size.height * 0.06,
            left: w * 0.18,
            right: w * 0.18,
            child: FadeTransition(
              opacity: fade,
              child: Image.asset(AppAssets.splashMosque),
            ),
          ),
          // Hanging lantern
          Positioned(
            top: 0,
            right: w * 0.07,
            width: w * 0.1,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, -1), end: Offset.zero)
                  .animate(fade),
              child: Image.asset(AppAssets.splashLantern),
            ),
          ),
          // Flowers
          Positioned(
            top: size.height * 0.23,
            left: 0,
            width: w * 0.2,
            child: Image.asset(AppAssets.splashFlowerLeft),
          ),
          Positioned(
            bottom: size.height * 0.14,
            right: 0,
            width: w * 0.23,
            child: Image.asset(AppAssets.splashFlowerRight),
          ),
          // Logo
          Center(
            child: ScaleTransition(
              scale: Tween(begin: 0.7, end: 1.0).animate(fade),
              child: FadeTransition(
                opacity: fade,
                child: Image.asset(AppAssets.islamiLogo, width: w * 0.4),
              ),
            ),
          ),
          // Route branding
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(AppAssets.routeBranding, width: w * 0.57),
            ),
          ),
        ],
      ),
    );
  }
}
