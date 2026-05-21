import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/step_repository.dart';

part 'leaderboard_screen.g.dart';

// Leaderboard entry — one user's data
class LeaderboardEntry {
  final String uid;
  final String name;
  final int    steps;
  final int    rank;

  const LeaderboardEntry({
    required this.uid,
    required this.name,
    required this.steps,
    required this.rank,
  });
}

@riverpod
Stream<List<LeaderboardEntry>> leaderboard(LeaderboardRef ref) {
  // Real-time stream — leaderboard updates live as others sync
  // Firestore free tier: 50k reads/day — plenty for a leaderboard
  return FirebaseFirestore.instance
      .collection('leaderboard')
      .orderBy('steps', descending: true)
      .limit(50)
      .snapshots()
      .map((snap) {
    return snap.docs.asMap().entries.map((e) {
      final data = e.value.data();
      return LeaderboardEntry(
        uid:   e.value.id,
        name:  data['name']  as String? ?? 'Anonymous',
        steps: data['steps'] as int?    ?? 0,
        rank:  e.key + 1,
      );
    }).toList();
  });
}

// Sync this user's steps to Firestore leaderboard
@riverpod
class LeaderboardSync extends _$LeaderboardSync {
  @override
  bool build() => false; // false = not syncing

  Future<void> syncToday() async {
    state = true;
    try {
      final user      = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final stepEntry = await StepRepository().getTodayEntry();
      final steps     = stepEntry?.stepCount ?? 0;

      // Write or update user's entry in the leaderboard collection
      await FirebaseFirestore.instance
          .collection('leaderboard')
          .doc(user.uid)
          .set({
        'name':      user.displayName ?? 'User',
        'steps':     steps,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } finally {
      state = false;
    }
  }
}

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final isSyncing        = ref.watch(leaderboardSyncProvider);
    final currentUid       = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Leaderboard',
            style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton.icon(
            onPressed: isSyncing
                ? null
                : () => ref
                .read(leaderboardSyncProvider.notifier)
                .syncToday(),
            icon: isSyncing
                ? const SizedBox(width: 14, height: 14,
                child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.sync_rounded,
                color: AppColors.primary, size: 18),
            label: const Text('Sync',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: leaderboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:   (e, _) => Center(child: Text('Error: $e')),
        data:    (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events_rounded,
                      size: 52, color: AppColors.textHint),
                  const SizedBox(height: 12),
                  Text('No one here yet!',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 6),
                  Text('Tap Sync to add your steps',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: entries.length,
            itemBuilder: (ctx, i) {
              final entry   = entries[i];
              final isMe    = entry.uid == currentUid;

              return _LeaderboardRow(
                entry: entry,
                isMe:  isMe,
              );
            },
          );
        },
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isMe;
  const _LeaderboardRow({required this.entry, required this.isMe});

  Color get _rankColor {
    switch (entry.rank) {
      case 1: return const Color(0xFFFFD700); // gold
      case 2: return const Color(0xFFB0BEC5); // silver
      case 3: return const Color(0xFFFF8F00); // bronze
      default: return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.primary.withOpacity(0.08)
            : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMe
              ? AppColors.primary.withOpacity(0.4)
              : AppColors.surfaceMuted,
          width: isMe ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 36,
            child: entry.rank <= 3
                ? Icon(Icons.emoji_events_rounded,
                color: _rankColor, size: 22)
                : Text(
              '#${entry.rank}',
              style: TextStyle(
                  color: _rankColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),

          // Avatar initial
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                entry.name.isNotEmpty
                    ? entry.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name
          Expanded(
            child: Text(
              isMe ? '${entry.name} (You)' : entry.name,
              style: TextStyle(
                color: isMe ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isMe ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),

          // Steps
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatSteps(entry.steps),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: entry.rank == 1
                      ? const Color(0xFFFFD700)
                      : AppColors.textPrimary,
                ),
              ),
              const Text('steps',
                  style: TextStyle(
                      fontSize: 10, color: AppColors.textHint)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return '$steps';
  }
}