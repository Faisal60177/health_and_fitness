import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _key     = 'theme_mode';

  @override
  ThemeMode build() {
    // Load persisted theme on startup
    Future.microtask(_loadTheme);
    return ThemeMode.dark; // default
  }

  Future<void> _loadTheme() async {
    final saved = await _storage.read(key: _key);
    if (saved == 'light') state = ThemeMode.light;
    if (saved == 'dark')  state = ThemeMode.dark;
    if (saved == 'system') state = ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await _storage.write(key: _key, value: mode.name);
  }

  void toggle() {
    setTheme(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}



