import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class ShellScreen extends StatelessWidget {
  // 'child' is the current tab's screen — injected by ShellRoute
  final Widget child;

  const ShellScreen({super.key, required this.child});

  // Maps each tab index to its route path
  static const _tabs = [
    AppRoutes.home,
    AppRoutes.workout,
    AppRoutes.nutrition,
    AppRoutes.analytics,
    AppRoutes.profile,
  ];

  // Figures out which tab index is active based on current URL
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _tabs.indexWhere((t) => location.startsWith(t));
    return index < 0 ? 0 : index; // default to home if no match
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      // The active tab's screen fills this area
      body: child,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border(
            top: BorderSide(
              color: AppColors.surfaceMuted,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          // SafeArea pushes the nav bar above the phone's home indicator
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () => context.go(AppRoutes.home),
                ),
                _NavItem(
                  icon: Icons.fitness_center_rounded,
                  label: 'Workout',
                  isActive: currentIndex == 1,
                  onTap: () => context.go(AppRoutes.workout),
                ),
                _NavItem(
                  icon: Icons.restaurant_rounded,
                  label: 'Nutrition',
                  isActive: currentIndex == 2,
                  onTap: () => context.go(AppRoutes.nutrition),
                ),
                _NavItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Analytics',
                    isActive: currentIndex == 3,
                    onTap: () => context.go(AppRoutes.analytics)),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isActive: currentIndex == 4,
                  onTap: () => context.go(AppRoutes.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// A single tab button — private, only used inside ShellScreen
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Active tab gets brand color, inactive gets muted
    final color = isActive ? AppColors.primary : AppColors.textHint;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                // Active tab gets a subtle pill highlight behind icon
                color: isActive
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}