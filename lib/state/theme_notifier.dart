import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


final themeNotifier = StateNotifierProvider((ref)=> ThemeState());

class ThemeState extends StateNotifier<bool> {
  ThemeState([bool isDarkTheme]) : super(isDarkTheme = false){
    _getThemePrefs();
  }

  final String key = "theme";
  SharedPreferences _prefs;

  void _getThemePrefs() async {
    await _initPrefs();
    state = _prefs.getBool(key) ?? false;
  }

  void _setThemPrefs () async {
    await _initPrefs();
    _prefs.setBool(key, state);
  }

  void _initPrefs() async {
    if(_prefs == null){
      _prefs = await SharedPreferences.getInstance();
    }
  }

  void toggleTheme () {
    state = !state;
    _setThemPrefs();
  }
}