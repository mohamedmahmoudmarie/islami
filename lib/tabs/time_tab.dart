import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';
import '../widgets/tab_background.dart';

class _Prayer {
  final String name;
  final int hour; // 24h
  final int minute;
  const _Prayer(this.name, this.hour, this.minute);

  String get time12 {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return '${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String get period => hour < 12 ? 'AM' : 'PM';
}

/// Time tab.
/// NOTE: prayer times below are fixed sample values (same as the design).
/// To get real times, call an API such as aladhan.com with the user's city.
class TimeTab extends StatefulWidget {
  const TimeTab({super.key});

  @override
  State<TimeTab> createState() => _TimeTabState();
}

class _TimeTabState extends State<TimeTab> {
  static const _prayers = [
    _Prayer('Fajr', 4, 21),
    _Prayer('Sunrise', 6, 4),
    _Prayer('Dhuhr', 13, 1),
    _Prayer('ASR', 16, 38),
    _Prayer('Maghrib', 19, 57),
    _Prayer('Isha', 21, 24),
  ];

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _hijriMonths = [
    'Muh', 'Saf', 'Rab I', 'Rab II', 'Jum I', 'Jum II',
    'Raj', 'Sha', 'Ram', 'Shaw', 'Dhu Q', 'Dhu H',
  ];
  static const _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];

  late Timer _timer;
  DateTime _now = DateTime.now();
  bool _muted = false;
  late final PageController _pageController = PageController(
    viewportFraction: 0.27,
    initialPage: _nextIndex,
  );
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _page = _nextIndex.toDouble();
    _pageController.addListener(
      () => setState(() => _page = _pageController.page ?? _page),
    );
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  DateTime _at(_Prayer p, DateTime day) =>
      DateTime(day.year, day.month, day.day, p.hour, p.minute);

  int get _nextIndex {
    final now = DateTime.now();
    final i = _prayers.indexWhere((p) => _at(p, now).isAfter(now));
    return i == -1 ? 0 : i;
  }

  String get _remaining {
    final i = _nextIndex;
    var next = _at(_prayers[i], _now);
    if (!next.isAfter(_now)) next = next.add(const Duration(days: 1));
    final d = next.difference(_now);
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Tabular (Kuwaiti) Hijri conversion — good enough for display.
  (int, int, int) _hijri(DateTime g) {
    final a = (14 - g.month) ~/ 12;
    final y = g.year + 4800 - a;
    final m = g.month + 12 * a - 3;
    final jd = g.day + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - y ~/ 100 +
        y ~/ 400 - 32045;
    var l = jd - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l - ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) + 29;
    final month = (24 * l) ~/ 709;
    final day = l - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;
    return (day, month, year);
  }

  @override
  Widget build(BuildContext context) {
    return TabBackground(
      background: AppAssets.timeBg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          _prayerCard(),
          const SizedBox(height: 24),
          const Text(
            'Azkar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _AzkarCard(
                  title: 'Evening Azkar',
                  icon: Icons.nightlight_round,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _AzkarCard(
                  title: 'Morning Azkar',
                  icon: Icons.wb_sunny_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prayerCard() {
    final (hd, hm, hy) = _hijri(_now);
    const white16 = TextStyle(
      color: AppColors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      height: 1.5,
    );

    return LayoutBuilder(builder: (context, c) {
    final cornerW = c.maxWidth * 0.3;
    return Container(
      height: 300,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        children: [
          // Brown top corners with the dates
          Positioned(
            top: 0,
            left: 0,
            width: cornerW,
            height: 80,
            child: Container(
              padding: const EdgeInsets.only(left: 24, top: 12),
              decoration: const BoxDecoration(
                color: AppColors.brown,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Text(
                '${_now.day.toString().padLeft(2, '0')} '
                '${_months[_now.month - 1]},\n${_now.year}',
                style: white16,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            width: cornerW,
            height: 80,
            child: Container(
              padding: const EdgeInsets.only(right: 24, top: 12),
              decoration: const BoxDecoration(
                color: AppColors.brown,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                ),
              ),
              child: Text(
                '${hd.toString().padLeft(2, '0')} ${_hijriMonths[hm - 1]},\n$hy',
                textAlign: TextAlign.end,
                style: white16,
              ),
            ),
          ),
          // Center title
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Pray Time',
                  style: TextStyle(
                    color: AppColors.black.withOpacity(0.7),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _days[_now.weekday - 1],
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Prayer cards
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            height: 130,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _prayers.length,
              itemBuilder: (_, i) {
                final diff = (_page - i).abs().clamp(0.0, 1.0);
                return Transform.scale(
                  scale: 1 - diff * 0.18,
                  child: _PrayerItem(prayer: _prayers[i]),
                );
              },
            ),
          ),
          // Next prayer + mute
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Row(
              children: [
                const Spacer(flex: 2),
                Text.rich(
                  TextSpan(
                    text: 'Next Pray - ',
                    style: TextStyle(
                      color: AppColors.black.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: _remaining,
                        style: const TextStyle(color: AppColors.black),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => setState(() => _muted = !_muted),
                  icon: Icon(
                    _muted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
    });
  }
}

class _PrayerItem extends StatelessWidget {
  final _Prayer prayer;
  const _PrayerItem({required this.prayer});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: AppColors.white, fontWeight: FontWeight.bold);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: AppColors.prayerCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(prayer.name, style: style.copyWith(fontSize: 16)),
              Text(prayer.time12, style: style.copyWith(fontSize: 32)),
              Text(prayer.period, style: style.copyWith(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AzkarCard extends StatelessWidget {
  final String title;
  final IconData icon;
  const _AzkarCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 185 / 260,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.black,
          border: Border.all(color: AppColors.gold, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: Icon(icon, color: AppColors.gold, size: 90),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
