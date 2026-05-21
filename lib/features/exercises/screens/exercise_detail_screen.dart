import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/exercise_cache.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final ExerciseCache exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surfaceCard,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            flexibleSpace: FlexibleSpaceBar(
              background: _ExerciseGif(gifUrl: exercise.gifUrl),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      label: exercise.category,
                      icon: Icons.category_rounded,
                      color: AppColors.primary,
                    ),
                    _InfoChip(
                      label: exercise.equipment,
                      icon: Icons.fitness_center_rounded,
                      color: const Color(0xFFA78BFA),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (exercise.muscles.isNotEmpty) ...[
                  _SectionHeader('Primary Muscles'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: exercise.muscles
                        .map((m) => _InfoChip(
                      label: m,
                      icon: Icons.accessibility_new_rounded,
                      color: const Color(0xFFFF7043),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                if (exercise.musclesSecondary.isNotEmpty) ...[
                  _SectionHeader('Secondary Muscles'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: exercise.musclesSecondary
                        .map((m) => _InfoChip(
                      label: m,
                      icon: Icons.accessibility_rounded,
                      color: AppColors.textSecondary,
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                _SectionHeader('Instructions'),
                const SizedBox(height: 12),
                ..._getInstructions(exercise)
                    .asMap()
                    .entries
                    .map((e) => _StepRow(
                  number: e.key + 1,
                  text: e.value,
                )),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add to active workout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getInstructions(ExerciseCache exercise) {
    if (exercise.description.isNotEmpty) {
      final steps = exercise.description
          .split('\n')
          .map((s) => s.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim())
          .where((s) => s.isNotEmpty)
          .toList();
      if (steps.isNotEmpty) return steps;
    }
    switch (exercise.category.toLowerCase()) {
      case 'chest':
        return [
          'Set up bench to proper height and lie flat.',
          'Grip bar slightly wider than shoulder width.',
          'Lower bar to mid-chest with control.',
          'Press up explosively, lock out at top.',
          'Keep feet flat on floor throughout.',
        ];
      case 'back':
        return [
          'Set up with neutral spine, hinge at hips.',
          'Engage lats before pulling.',
          'Drive elbows toward hips on the pull.',
          'Squeeze shoulder blades at peak contraction.',
          'Lower with control.',
        ];
      case 'upper legs':
        return [
          'Stand with feet shoulder-width apart.',
          'Keep chest up and core braced.',
          'Descend until thighs are parallel to floor.',
          'Drive through heels to stand up.',
          'Keep knees tracking over toes.',
        ];
      case 'waist':
        return [
          'Engage your core before starting.',
          'Move slowly and with control.',
          'Exhale on the contraction phase.',
          'Avoid pulling on your neck.',
          'Focus on muscle contraction, not speed.',
        ];
      default:
        return [
          'Warm up before starting.',
          'Focus on full range of motion.',
          'Control the eccentric (lowering) phase.',
          'Breathe out on the exertion.',
          'Stop if you feel sharp pain.',
        ];
    }
  }
}

// ── GIF viewer with loading + error states ────────────────────────────────────

class _ExerciseGif extends StatefulWidget {
  final String gifUrl;
  const _ExerciseGif({required this.gifUrl});

  @override
  State<_ExerciseGif> createState() => _ExerciseGifState();
}

class _ExerciseGifState extends State<_ExerciseGif> {
  bool _hasError = false;
  bool _isLoading = true;
  late final ImageProvider? _provider;

  @override
  void initState() {
    super.initState();
    if (widget.gifUrl.isEmpty) {
      _hasError = true;
      _isLoading = false;
      return;
    }
    _provider = NetworkImage(widget.gifUrl);
    final stream = _provider!.resolve(ImageConfiguration.empty);
    final listener = ImageStreamListener(
          (_, __) {
        if (mounted) setState(() => _isLoading = false);
      },
      onError: (_, __) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      },
    );
    stream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || widget.gifUrl.isEmpty) return const _GifPlaceholder();
    if (_isLoading) {
      return Container(
        color: AppColors.surfaceCard,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    return Image(
      image: _provider!,
      fit: BoxFit.contain,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => const _GifPlaceholder(),
    );
  }
}

class _GifPlaceholder extends StatelessWidget {
  const _GifPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceCard,
      child: const Center(
        child: Icon(
          Icons.fitness_center_rounded,
          color: AppColors.textHint,
          size: 64,
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Info chip (category, equipment, muscle) ───────────────────────────────────

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _InfoChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Numbered instruction step ─────────────────────────────────────────────────

class _StepRow extends StatelessWidget {
  final int number;
  final String text;
  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(right: 12, top: 1),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}