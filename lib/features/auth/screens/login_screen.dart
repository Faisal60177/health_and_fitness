import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey            = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword        = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authNotifierProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  Future<void> _handleGoogleSignIn() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  // Extract a clean readable message from AsyncError
  String _cleanError(Object error) {
    final msg = error.toString();
    // Remove "Exception: " prefix that Dart adds
    return msg.replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    // Check if the error message suggests using Google
    // so we can highlight the Google button
    final errorMsg = authState.hasError
        ? _cleanError(authState.error!)
        : null;
    final shouldHighlightGoogle = errorMsg != null &&
        errorMsg.toLowerCase().contains('google');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Logo
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.favorite_rounded,
                      color: AppColors.primary, size: 28),
                ),
                const SizedBox(height: 24),

                Text('Welcome back',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text('Sign in to continue your health journey',
                    style: Theme.of(context).textTheme.bodyMedium),

                const SizedBox(height: 40),

                // ── Error banner ──────────────────────────────
                if (errorMsg != null) ...[
                  _ErrorBanner(
                    message:         errorMsg,
                    highlightGoogle: shouldHighlightGoogle,
                    onGoogleTap:     shouldHighlightGoogle
                        ? _handleGoogleSignIn
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Email field ───────────────────────────────
                AuthTextField(
                  label:        'Email',
                  hint:         'you@example.com',
                  controller:   _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Password field ────────────────────────────
                AuthTextField(
                  label:       'Password',
                  hint:        'Your password',
                  controller:  _passwordController,
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.textHint, size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // ── Sign in button ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.black))
                        : const Text('Sign in',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Divider ───────────────────────────────────
                Row(
                  children: [
                    const Expanded(
                        child: Divider(color: AppColors.surfaceMuted)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    const Expanded(
                        child: Divider(color: AppColors.surfaceMuted)),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Google button ─────────────────────────────
                // Glows green when error tells user to use Google
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : _handleGoogleSignIn,
                    icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
                    label: const Text('Continue with Google'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      // ✅ Highlight border green if error says "use Google"
                      side: BorderSide(
                        color: shouldHighlightGoogle
                            ? AppColors.primary
                            : AppColors.surfaceMuted,
                        width: shouldHighlightGoogle ? 2 : 1,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Sign up link ──────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.signup),
                      child: const Text('Sign up',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error banner ──────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  final String message;
  final bool highlightGoogle;
  final VoidCallback? onGoogleTap;

  const _ErrorBanner({
    required this.message,
    this.highlightGoogle = false,
    this.onGoogleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: AppColors.danger, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: const TextStyle(
                        color: AppColors.danger, fontSize: 13)),
              ),
            ],
          ),
          // ✅ Show a quick Google tap button inside error if relevant
          if (highlightGoogle && onGoogleTap != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onGoogleTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.g_mobiledata_rounded,
                        color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text('Tap to sign in with Google',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}