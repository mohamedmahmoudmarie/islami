import 'package:flutter/material.dart';

import '../core/app_assets.dart';

/// Full-screen background image + the "Islami" header used on every tab.
class TabBackground extends StatelessWidget {
  final String background;
  final Widget child;

  const TabBackground({
    super.key,
    required this.background,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(background, fit: BoxFit.cover),
        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Center(child: Image.asset(AppAssets.header, width: 290)),
              const SizedBox(height: 16),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}
