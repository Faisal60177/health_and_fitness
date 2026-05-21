import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/iap_service.dart';

part 'premium_screen.g.dart';

@riverpod
class PremiumNotifier extends _$PremiumNotifier {
  final _service = IAPService();

  @override
  Future<List<ProductDetails>> build() async {
    await _service.initialize();
    return _service.getProducts();
  }

  Future<void> purchase(ProductDetails product) async {
    await _service.purchase(product);
  }

  Future<void> restore() async {
    await _service.restorePurchases();
  }
}

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  // Premium features list
  static const _features = [
    ('AI Coach', 'Unlimited AI-powered coaching sessions',
    Icons.psychology_rounded),
    ('Advanced Charts', 'Monthly trends and detailed analytics',
    Icons.bar_chart_rounded),
    ('Workout Plans', 'All 20+ advanced training programs',
    Icons.fitness_center_rounded),
    ('Export Reports', 'PDF and CSV export unlimited',
    Icons.ios_share_rounded),
    ('Health Connect', 'Full wearable integration',
    Icons.watch_rounded),
    ('Priority Support', 'Get help within 24 hours',
    Icons.support_agent_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(premiumNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Go Premium',
            style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(premiumNotifierProvider.notifier).restore(),
            child: const Text('Restore',
                style: TextStyle(color: AppColors.textHint)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end:   Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    const Color(0xFF7C3AED).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium_rounded,
                      color: AppColors.primary, size: 52),
                  const SizedBox(height: 12),
                  Text('Unlock Everything',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Get the most out of your health journey',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Features list
            ..._features.map((f) => _FeatureRow(
              icon:  f.$3,
              title: f.$1,
              desc:  f.$2,
            )),

            const SizedBox(height: 28),

            // Pricing plans from Play Store
            productsAsync.when(
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error:   (e, _) => _FallbackPricingCard(
                  onTap: () {}), // Show static price if Play Store unavailable
              data: (products) => products.isEmpty
                  ? _FallbackPricingCard(onTap: () {})
                  : Column(
                children: products
                    .map((p) => _ProductCard(
                  product: p,
                  onTap: () => ref
                      .read(premiumNotifierProvider.notifier)
                      .purchase(p),
                ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Legal
            Text(
              'Subscription auto-renews. Cancel anytime in Play Store settings. '
                  'Payment charged to Google Play account.',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String   title;
  final String   desc;
  const _FeatureRow({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600)),
                Text(desc,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 18),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductDetails product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});

  bool get _isYearly => product.id.contains('yearly');
  bool get _isLifetime => product.id.contains('lifetime');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _isYearly
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isYearly
                ? AppColors.primary
                : AppColors.surfaceMuted,
            width: _isYearly ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(product.title,
                          style: const TextStyle(
                              color:      AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize:   15)),
                      if (_isYearly) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('BEST VALUE',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isLifetime
                        ? 'Pay once, use forever'
                        : _isYearly
                        ? 'Billed annually — save 40%'
                        : 'Billed monthly',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text(
              product.price,
              style: const TextStyle(
                  color:      AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize:   18),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackPricingCard extends StatelessWidget {
  final VoidCallback onTap;
  const _FallbackPricingCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        children: [
          Text('Premium', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Available on the Play Store',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding:         const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('View Plans'),
            ),
          ),
        ],
      ),
    );
  }
}