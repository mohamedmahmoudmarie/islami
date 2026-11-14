import 'package:flutter/material.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';
import '../core/prefs.dart';
import 'home_screen.dart';

class _OnboardingPage {
  final String image;
  final String title;
  final String? description;
  const _OnboardingPage(this.image, this.title, [this.description]);
}

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static final _pages = [
    _OnboardingPage(AppAssets.onboarding[0], 'Welcome To Islami App'),
    _OnboardingPage(AppAssets.onboarding[1], 'Welcome To Islami',
        'We Are Very Excited To Have You In Our Community'),
    _OnboardingPage(AppAssets.onboarding[2], 'Reading the Quran',
        'Read, and your Lord is the Most Generous'),
    _OnboardingPage(AppAssets.onboarding[3], 'Bearish',
        'Praise the name of your Lord, the Most High'),
    _OnboardingPage(AppAssets.onboarding[4], 'Holy Quran Radio',
        'You can listen to the Holy Quran Radio through the application for free and easily'),
  ];

  bool get _isLast => _index == _pages.length - 1;

  Future<void> _finish() async {
    await Prefs.setOnboardingDone();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  void _go(int delta) {
    _controller.animateToPage(
      _index + delta,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const navStyle = TextStyle(
      color: AppColors.gold,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Image.asset(AppAssets.header, width: 290),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _PageBody(page: _pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: _index == 0
                        ? null
                        : GestureDetector(
                            onTap: () => _go(-1),
                            child: const Text('Back', style: navStyle),
                          ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) {
                        final active = i == _index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: active ? 18 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.gold
                                : const Color(0xFF707070),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: GestureDetector(
                      onTap: _isLast ? _finish : () => _go(1),
                      child: Text(
                        _isLast ? 'Finish' : 'Next',
                        style: navStyle,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageBody extends StatelessWidget {
  final _OnboardingPage page;
  const _PageBody({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Center(child: Image.asset(page.image)),
          ),
          const SizedBox(height: 24),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 2,
            child: page.description == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(
                      page.description!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.8,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
