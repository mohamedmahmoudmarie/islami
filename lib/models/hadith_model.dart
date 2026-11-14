import 'package:flutter/services.dart';

class HadithModel {
  final int number;
  final String title;
  final String content;

  const HadithModel({
    required this.number,
    required this.title,
    required this.content,
  });

  /// Loads assets/hadith/h1.txt ... h50.txt (whatever exists).
  /// Each file: first line = title, the rest = hadith text.
  static Future<List<HadithModel>> loadAll({int max = 50}) async {
    final list = <HadithModel>[];
    for (var i = 1; i <= max; i++) {
      try {
        final raw = await rootBundle.loadString('assets/hadith/h$i.txt');
        final lines = raw.trim().split('\n');
        list.add(HadithModel(
          number: i,
          title: lines.first.trim(),
          content: lines.skip(1).join('\n').trim(),
        ));
      } catch (_) {
        // File not added yet -> skip it.
      }
    }
    return list;
  }
}
