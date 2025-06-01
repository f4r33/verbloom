import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';
  static const String _notificationsKey = 'notifications_enabled';

  SettingsProvider(this._prefs);

  ThemeMode get themeMode {
    final themeIndex = _prefs.getInt(_themeKey) ?? 0;
    return ThemeMode.values[themeIndex];
  }

  bool get notificationsEnabled {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    final newMode = themeMode == ThemeMode.light
        ? ThemeMode.dark
        : themeMode == ThemeMode.dark
            ? ThemeMode.system
            : ThemeMode.light;
    await setThemeMode(newMode);
  }
} 