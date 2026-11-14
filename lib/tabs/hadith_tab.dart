import 'package:flutter/material.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';
import '../models/hadith_model.dart';
import '../screens/hadith_details_screen.dart';
import '../widgets/tab_background.dart';

class HadithTab extends StatefulWidget {
  const HadithTab({super.key});

  @override
  State<HadithTab> createState() => _HadithTabState();
}

class _HadithTabState extends State<HadithTab> {
  late final Future<List<HadithModel>> _future = HadithModel.loadAll();
  final _controller = PageController(viewportFraction: 0.75);
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _page = _controller.page ?? 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBackground(
      background: AppAssets.hadithBg,
      child: FutureBuilder<List<HadithModel>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          final list = snap.data!;
          if (list.isEmpty) {
            return const Center(
              child: Text('No hadith files in assets/hadith/'),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: PageView.builder(
              controller: _controller,
              itemCount: list.length,
              itemBuilder: (_, i) {
                // Side cards are a bit smaller, like the design.
                final diff = (_page - i).abs().clamp(0.0, 1.0);
                final scale = 1 - diff * 0.12;
                return Transform.scale(
                  scale: scale,
                  child: HadithCard(
                    hadith: list[i],
                    onTap: () => Navigator.pushNamed(
                      context,
                      HadithDetailsScreen.routeName,
                      arguments: list[i],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class HadithCard extends StatelessWidget {
  final HadithModel hadith;
  final VoidCallback onTap;

  const HadithCard({super.key, required this.hadith, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 70),
                child: Image.asset(AppAssets.hadithCardBg, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                AppAssets.mosqueSilhouette,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Image.asset(AppAssets.cornerLeftDark, width: 80),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Image.asset(AppAssets.cornerRightDark, width: 80),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 70),
              child: Column(
                children: [
                  Text(
                    hadith.title,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        hadith.content,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.9,
                        ),
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
