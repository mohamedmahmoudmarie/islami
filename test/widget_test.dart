import 'package:flutter_test/flutter_test.dart';
import 'package:islami/data/quran_data.dart';

void main() {
  test('Quran data has 114 suras and 6236 verses', () {
    expect(QuranData.suras.length, 114);
    expect(QuranData.versesCount.reduce((a, b) => a + b), 6236);
  });
}
