import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_assets.dart';
import '../widgets/tab_background.dart';

class SebhaTab extends StatefulWidget {
  const SebhaTab({super.key});

  @override
  State<SebhaTab> createState() => _SebhaTabState();
}

class _SebhaTabState extends State<SebhaTab> {
  static const _azkar = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
  ];
  static const _beads = 33;

  int _counter = 0;
  int _zikrIndex = 0;
  double _turns = 0;

  void _onTap() {
    setState(() {
      _turns += 1 / _beads;
      _counter++;
      if (_counter == _beads) {
        _counter = 0;
        _zikrIndex = (_zikrIndex + 1) % _azkar.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const white36 = TextStyle(
      color: Colors.white,
      fontSize: 36,
      fontWeight: FontWeight.bold,
    );

    return TabBackground(
      background: AppAssets.sebhaBg,
      child: Column(
        children: [
          const Text(
            'سَبِّحِ اسْمَ رَبِّكَ الأعلى',
            textDirection: TextDirection.rtl,
            style: white36,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                // Body is ~88% of screen width; head is ~38% of the body.
                final body = min(c.maxWidth * 0.88, c.maxHeight * 0.78);
                final headW = body * 0.38;
                final headH = headW * 344 / 580;
                return Center(
                  child: GestureDetector(
                    onTap: _onTap,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: body,
                      height: body + headH - 6,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: headH - 6,
                            child: AnimatedRotation(
                              turns: _turns,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              child: Image.asset(
                                AppAssets.sebhaBody,
                                width: body,
                                height: body,
                              ),
                            ),
                          ),
                          Image.asset(
                            AppAssets.sebhaHead,
                            width: headW,
                            height: headH,
                          ),
                          Positioned(
                            top: headH - 6,
                            width: body,
                            height: body,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _azkar[_zikrIndex],
                                  textDirection: TextDirection.rtl,
                                  style: white36,
                                ),
                                const SizedBox(height: 24),
                                Text('$_counter', style: white36),
                              ],
                            ),
                          ),
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
