class SuraModel {
  final int number;
  final String englishName;
  final String arabicName;
  final int versesCount;

  const SuraModel({
    required this.number,
    required this.englishName,
    required this.arabicName,
    required this.versesCount,
  });

  /// Path of the text file holding this sura (one verse per line).
  String get filePath => 'assets/suras/$number.txt';
}
