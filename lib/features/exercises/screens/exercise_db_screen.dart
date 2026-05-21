import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/exercise_cache.dart';
import '../../../data/services/exercise_api_service.dart';
import '../providers/exercise_provider.dart';
import 'exercise_detail_screen.dart';
// ← removed: cached_network_image, gif_view

class ExerciseDatabaseScreen extends ConsumerStatefulWidget {
  const ExerciseDatabaseScreen({super.key});

  @override
  ConsumerState<ExerciseDatabaseScreen> createState() =>
      _ExerciseDatabaseScreenState();
}

class _ExerciseDatabaseScreenState
    extends ConsumerState<ExerciseDatabaseScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Exercise Database',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                hintStyle: const TextStyle(color: AppColors.textHint),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textHint),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear_rounded,
                      color: AppColors.textHint),
                  onPressed: () {
                    _searchController.clear();
                    ref
                        .read(exerciseNotifierProvider.notifier)
                        .clearSearch();
                  },
                )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (q) =>
                  ref.read(exerciseNotifierProvider.notifier).search(q),
            ),
          ),

          // Category filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _CategoryChip(
                  label: 'All',
                  isSelected: state.selectedCategory == null,
                  onTap: () => ref
                      .read(exerciseNotifierProvider.notifier)
                      .loadExercises(),
                ),
                ...ExerciseApiService.categoryDisplayMap.entries.map(
                      (e) => _CategoryChip(
                    label: e.value,
                    isSelected: state.selectedCategory == e.key,
                    onTap: () => ref
                        .read(exerciseNotifierProvider.notifier)
                        .loadExercises(categoryId: e.key),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Exercise list
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? _ErrorState(message: state.error!)
                : state.exercises.isEmpty
                ? _EmptyState(searchTerm: state.searchTerm)
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.exercises.length,
              itemBuilder: (ctx, i) => _ExerciseListTile(
                exercise: state.exercises[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseDetailScreen(
                      exercise: state.exercises[i],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.black : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ── Updated tile — uses _GifThumbnail instead of raw Image.network ────────────

class _ExerciseListTile extends StatelessWidget {
  final ExerciseCache exercise;
  final VoidCallback onTap;

  const _ExerciseListTile({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceMuted),
        ),
        child: Row(
          children: [
            // Animated GIF thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14),
              ),
              child: _GifThumbnail(
                gifUrl: exercise.gifUrl,
                width: 90,
                height: 90,
              ),
            ),

            // Exercise info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _MuscleChip(exercise.category),
                        const SizedBox(width: 6),
                        if (exercise.equipment.isNotEmpty)
                          _MuscleChip(
                            exercise.equipment.split(',').first.trim(),
                            color: AppColors.surfaceMuted,
                          ),
                      ],
                    ),
                    if (exercise.muscles.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        exercise.muscles.take(2).join(' · '),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _MuscleChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MuscleChip(this.label, {this.color = const Color(0xFF00C896)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 10, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String searchTerm;
  const _EmptyState({required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 48, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            searchTerm.isEmpty
                ? 'No exercises found'
                : 'No results for "$searchTerm"',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// ── GIF thumbnail with loading + error states ─────────────────────────────────

class _GifThumbnail extends StatefulWidget {
  final String gifUrl;
  final double width;
  final double height;

  const _GifThumbnail({
    required this.gifUrl,
    required this.width,
    required this.height,
  });

  @override
  State<_GifThumbnail> createState() => _GifThumbnailState();
}

class _GifThumbnailState extends State<_GifThumbnail> {
  late final ImageProvider _provider;
  bool _hasError = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.gifUrl.isEmpty) {
      _hasError = true;
      _isLoading = false;
      return;
    }
    _provider = NetworkImage(widget.gifUrl);
    final stream = _provider.resolve(ImageConfiguration.empty);
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
    if (_hasError || widget.gifUrl.isEmpty) {
      return _Placeholder(width: widget.width, height: widget.height);
    }
    if (_isLoading) {
      return _LoadingPlaceholder(width: widget.width, height: widget.height);
    }
    return Image(
      image: _provider,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) =>
          _Placeholder(width: widget.width, height: widget.height),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double width;
  final double height;
  const _Placeholder({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceMuted,
      child: const Icon(Icons.fitness_center_rounded,
          color: AppColors.textHint, size: 28),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  const _LoadingPlaceholder({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceMuted,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}