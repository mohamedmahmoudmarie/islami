import 'package:flutter/material.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';

/// Shared layout for Sura / Hadith details:
/// app bar + golden corners + Arabic title + content + mosque decoration.
class DetailsLayout extends StatelessWidget {
  final String appBarTitle;
  final String title;
  final Widget child;

  const DetailsLayout({
    super.key,
    required this.appBarTitle,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              AppAssets.bottomDecoration,
              fit: BoxFit.fitWidth,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 92,
                  child: Row(
                    children: [
                      Image.asset(AppAssets.cornerLeftGold, width: 92),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Image.asset(AppAssets.cornerRightGold, width: 92),
                    ],
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ],
      ),
    );
  }
}
