import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';
import '../models/sura_model.dart';
import '../widgets/details_layout.dart';

class SuraDetailsScreen extends StatefulWidget {
  static const routeName = '/sura-details';
  const SuraDetailsScreen({super.key});

  @override
  State<SuraDetailsScreen> createState() => _SuraDetailsScreenState();
}

class _SuraDetailsScreenState extends State<SuraDetailsScreen> {
  Future<List<String>>? _verses;
  int? _selected;

  Future<List<String>> _load(SuraModel sura) async {
    final text = await rootBundle.loadString(sura.filePath);
    return text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final sura = ModalRoute.of(context)!.settings.arguments as SuraModel;
    _verses ??= _load(sura);

    return DetailsLayout(
      appBarTitle: sura.englishName,
      title: sura.arabicName,
      child: FutureBuilder<List<String>>(
        future: _verses,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          if (snap.hasError || (snap.data?.isEmpty ?? true)) {
            return _MissingFile(path: sura.filePath);
          }
          final verses = snap.data!;
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            itemCount: verses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final selected = _selected == i;
              return GestureDetector(
                onTap: () => setState(() => _selected = selected ? null : i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.gold : AppColors.black,
                    border: Border.all(color: AppColors.gold),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${verses[i]} [${i + 1}]',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: selected ? AppColors.black : AppColors.gold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.9,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MissingFile extends StatelessWidget {
  final String path;
  const _MissingFile({required this.path});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'ملف السورة غير موجود\n$path',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
