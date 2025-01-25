import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';

class SettingsService {
  static const _key = 'app_settings';

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      totalWeeks: prefs.getInt('totalWeeks') ?? 20,
      startDate: DateTime.parse(prefs.getString('startDate') ?? DateTime.now().toString()),
      showWeekend: prefs.getBool('showWeekend') ?? true,
      showOtherWeeks: prefs.getBool('showOtherWeeks') ?? false,
      classDuration: prefs.getInt('classDuration') ?? 40,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalWeeks', settings.totalWeeks);
    await prefs.setString('startDate', settings.startDate.toIso8601String());
    await prefs.setBool('showWeekend', settings.showWeekend);
    await prefs.setBool('showOtherWeeks', settings.showOtherWeeks);
    await prefs.setInt('classDuration', settings.classDuration);
  }
}