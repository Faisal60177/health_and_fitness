import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// Product IDs — must match exactly what you set up in Play Console
class IAPProducts {
  // Monthly subscription
  static const monthlyPremium = 'health_premium_monthly';
  // Annual subscription
  static const yearlyPremium  = 'health_premium_yearly';
  // One-time purchase
  static const lifetimePremium = 'health_premium_lifetime';

  static const all = {
    monthlyPremium,
    yearlyPremium,
    lifetimePremium,
  };
}

class IAPService {
  static final _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isPremium = false;

  bool get isPremium => _isPremium;

  // Initialize and listen to purchase updates
  Future<void> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) return;

    // Listen to the purchase stream
    // This fires when: new purchase, restore, error
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (e) => debugPrint('IAP stream error: $e'),
    );
  }

  // Load available products from Play Store
  Future<List<ProductDetails>> getProducts() async {
    final response = await _iap.queryProductDetails(IAPProducts.all);

    if (response.error != null) {
      debugPrint('IAP error: ${response.error}');
      return [];
    }

    return response.productDetails;
  }

  // Trigger purchase flow
  Future<void> purchase(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);

    // For subscriptions — use buyNonConsumable
    // For one-time (consumable like extra AI credits) — use buyConsumable
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  // Restore past purchases (required by Play Store policies)
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  // Handle all purchase state changes
  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
        // Verify purchase server-side in production!
        // For now just unlock premium
          _isPremium = true;
          // Must call completePurchase to finalize
          _iap.completePurchase(purchase);
          break;

        case PurchaseStatus.error:
          debugPrint('Purchase error: ${purchase.error}');
          break;

        case PurchaseStatus.canceled:
          debugPrint('Purchase cancelled');
          break;

        case PurchaseStatus.pending:
        // Show "processing" state in UI
          break;
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}