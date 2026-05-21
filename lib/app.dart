import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/theme_provider.dart';

// Changed from StatelessWidget to ConsumerWidget
// so it can watch the appRouterProvider
class HealthApp extends ConsumerWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider — rebuilds if router changes
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeNotifierProvider);


    return MaterialApp.router(
      title: 'Health & Fitness',
      debugShowCheckedModeBanner: false,
      theme:      AppTheme.lightTheme,   // light theme
      darkTheme:  AppTheme.darkTheme,    // dark theme
      themeMode:  themeMode,             // controlled by provider
      routerConfig: router,  // same as before, now from provider
    );
  }
}