import 'package:shared_preferences/shared_preferences.dart';

/// Small wrapper around SharedPreferences.
abstract class Prefs {
  static late SharedPreferences _prefs;

  static const _onboardingKey = 'onboarding_done';
  static const _recentKey = 'recent_suras';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get onboardingDone => _prefs.getBool(_onboardingKey) ?? false;

  static Future<void> setOnboardingDone() =>
      _prefs.setBool(_onboardingKey, true);

  /// Sura numbers (1..114), most recent first.
  static List<int> get recentSuras =>
      (_prefs.getStringList(_recentKey) ?? []).map(int.parse).toList();

  static Future<void> addRecentSura(int number) async {
    final list = recentSuras..remove(number);
    list.insert(0, number);
    await _prefs.setStringList(
      _recentKey,
      list.take(10).map((e) => '$e').toList(),
    );
  }
}
