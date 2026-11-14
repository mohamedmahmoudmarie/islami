import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';
import '../widgets/tab_background.dart';

/// Radio tab (UI only).
/// To actually stream audio later, add the `just_audio` package and
/// play the station URL inside [_togglePlay].
class RadioTab extends StatefulWidget {
  const RadioTab({super.key});

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> {
  static const _radios = [
    'Radio Ibrahim Al-Akdar',
    'Radio Al-Qaria Yassen',
    'Radio Ahmed Al-trabulsi',
    'Radio Addokali Mohammad Alalim',
  ];
  static const _reciters = [
    'Ibrahim Al-Akdar',
    'Akram Alalaqmi',
    'Majed Al-Enezi',
    'Malik shaibat Alhamed',
  ];

  int _section = 0; // 0 = Radio, 1 = Reciters
  String? _playing;
  final Set<String> _muted = {};

  void _togglePlay(String name) =>
      setState(() => _playing = _playing == name ? null : name);

  void _toggleMute(String name) => setState(
      () => _muted.contains(name) ? _muted.remove(name) : _muted.add(name));

  @override
  Widget build(BuildContext context) {
    final items = _section == 0 ? _radios : _reciters;

    return TabBackground(
      background: AppAssets.radioBg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _sectionButton('Radio', 0),
                  _sectionButton('Reciters', 1),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _RadioCard(
                name: items[i],
                playing: _playing == items[i],
                muted: _muted.contains(items[i]),
                onPlay: () => _togglePlay(items[i]),
                onMute: () => _toggleMute(items[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionButton(String text, int index) {
    final selected = _section == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _section = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? AppColors.black : AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioCard extends StatelessWidget {
  final String name;
  final bool playing;
  final bool muted;
  final VoidCallback onPlay;
  final VoidCallback onMute;

  const _RadioCard({
    required this.name,
    required this.playing,
    required this.muted,
    required this.onPlay,
    required this.onMute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 133,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: playing
                ? const _SoundWave()
                : Image.asset(
                    AppAssets.mosqueSilhouette,
                    fit: BoxFit.fitWidth,
                  ),
          ),
          Column(
            children: [
              const SizedBox(height: 16),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 40),
                  IconButton(
                    onPressed: onPlay,
                    iconSize: 48,
                    icon: Icon(
                      playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: AppColors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: onMute,
                    iconSize: 32,
                    icon: Icon(
                      muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}

/// Simple static "audio wave" bars shown while a station is playing.
class _SoundWave extends StatelessWidget {
  const _SoundWave();

  @override
  Widget build(BuildContext context) {
    final rnd = Random(7);
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          38,
          (_) => Container(
            width: 3,
            height: 20 + rnd.nextDouble() * 50,
            color: AppColors.black.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
