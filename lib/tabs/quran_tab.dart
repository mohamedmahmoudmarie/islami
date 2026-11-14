import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';
import '../core/prefs.dart';
import '../data/quran_data.dart';
import '../models/sura_model.dart';
import '../screens/sura_details_screen.dart';
import '../widgets/tab_background.dart';

class QuranTab extends StatefulWidget {
  const QuranTab({super.key});

  @override
  State<QuranTab> createState() => _QuranTabState();
}

class _QuranTabState extends State<QuranTab> {
  final _search = TextEditingController();
  String _query = '';

  List<SuraModel> get _filtered {
    if (_query.isEmpty) return QuranData.suras;
    final q = _query.toLowerCase();
    return QuranData.suras
        .where((s) =>
            s.englishName.toLowerCase().contains(q) ||
            s.arabicName.contains(_query) ||
            '${s.number}' == q)
        .toList();
  }

  List<SuraModel> get _recent =>
      Prefs.recentSuras.map((n) => QuranData.suras[n - 1]).toList();

  Future<void> _open(SuraModel sura) async {
    FocusScope.of(context).unfocus();
    await Prefs.addRecentSura(sura.number);
    if (!mounted) return;
    await Navigator.pushNamed(
      context,
      SuraDetailsScreen.routeName,
      arguments: sura,
    );
    setState(() {}); // refresh "Most Recently"
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suras = _filtered;
    final recent = _recent;

    return TabBackground(
      background: AppAssets.quranBg,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _searchField()),
          if (_query.isEmpty && recent.isNotEmpty) ...[
            const SliverToBoxAdapter(child: _SectionTitle('Most Recently')),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: recent.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) => _RecentCard(
                    sura: recent[i],
                    onTap: () => _open(recent[i]),
                  ),
                ),
              ),
            ),
          ],
          if (_query.isEmpty)
            const SliverToBoxAdapter(child: _SectionTitle('Suras List')),
          if (suras.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No sura found',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          SliverList.separated(
            itemCount: suras.length,
            separatorBuilder: (_, __) => const Divider(
              color: AppColors.white,
              thickness: 1,
              height: 1,
              indent: 64,
              endIndent: 64,
            ),
            itemBuilder: (_, i) => _SuraItem(
              sura: suras[i],
              onTap: () => _open(suras[i]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _searchField() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.gold),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: TextField(
        controller: _search,
        onChanged: (v) => setState(() => _query = v.trim()),
        cursorColor: AppColors.gold,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: 'Sura Name',
          hintStyle: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: AppColors.black.withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SvgPicture.asset(
              AppAssets.icQuran,
              height: 24,
              colorFilter:
                  const ColorFilter.mode(AppColors.gold, BlendMode.srcIn),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 52),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, color: AppColors.gold),
                  onPressed: () {
                    _search.clear();
                    setState(() => _query = '');
                  },
                ),
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: AppColors.gold, width: 2),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RecentCard extends StatelessWidget {
  final SuraModel sura;
  final VoidCallback onTap;
  const _RecentCard({required this.sura, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const dark = TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.bold,
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 283,
        padding: const EdgeInsets.fromLTRB(17, 14, 6, 14),
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(sura.englishName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: dark.copyWith(fontSize: 24)),
                  Text(sura.arabicName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: dark.copyWith(fontSize: 24)),
                  Text('${sura.versesCount} Verses',
                      style: dark.copyWith(fontSize: 14)),
                ],
              ),
            ),
            Image.asset(AppAssets.mostRecent, width: 140),
          ],
        ),
      ),
    );
  }
}

class _SuraItem extends StatelessWidget {
  final SuraModel sura;
  final VoidCallback onTap;
  const _SuraItem({required this.sura, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(AppAssets.suraNumberFrame),
                  Text(
                    '${sura.number}',
                    style: TextStyle(
                      fontSize: sura.number > 99 ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sura.englishName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${sura.versesCount} Verses',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Text(
              sura.arabicName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
