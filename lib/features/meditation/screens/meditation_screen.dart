import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// Breathing technique definition
class BreathingTechnique {
  final String name;
  final String description;
  final int inhaleSeconds;
  final int holdInSeconds;    // hold after inhale
  final int exhaleSeconds;
  final int holdOutSeconds;   // hold after exhale
  final Color color;
  final String benefit;

  const BreathingTechnique({
    required this.name,
    required this.description,
    required this.inhaleSeconds,
    required this.holdInSeconds,
    required this.exhaleSeconds,
    required this.holdOutSeconds,
    required this.color,
    required this.benefit,
  });

  int get totalCycleSeconds =>
      inhaleSeconds + holdInSeconds + exhaleSeconds + holdOutSeconds;
}

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with TickerProviderStateMixin {
  static const _techniques = [
    BreathingTechnique(
      name: '4-7-8 Breathing',
      description: 'Inhale 4s · Hold 7s · Exhale 8s',
      inhaleSeconds:  4,
      holdInSeconds:  7,
      exhaleSeconds:  8,
      holdOutSeconds: 0,
      color: Color(0xFF7C3AED),
      benefit: 'Reduces anxiety · Aids sleep onset',
    ),
    BreathingTechnique(
      name: 'Box Breathing',
      description: 'Inhale 4s · Hold 4s · Exhale 4s · Hold 4s',
      inhaleSeconds:  4,
      holdInSeconds:  4,
      exhaleSeconds:  4,
      holdOutSeconds: 4,
      color: Color(0xFF0EA5E9),
      benefit: 'Calms nervous system · Improves focus',
    ),
    BreathingTechnique(
      name: 'Deep Belly Breathing',
      description: 'Inhale 5s · Hold 2s · Exhale 5s',
      inhaleSeconds:  5,
      holdInSeconds:  2,
      exhaleSeconds:  5,
      holdOutSeconds: 0,
      color: AppColors.primary,
      benefit: 'Reduces cortisol · General relaxation',
    ),
    BreathingTechnique(
      name: 'Energizing Breath',
      description: 'Inhale 2s · Exhale 2s · Fast rhythm',
      inhaleSeconds:  2,
      holdInSeconds:  0,
      exhaleSeconds:  2,
      holdOutSeconds: 0,
      color: const Color(0xFFFF7043),
      benefit: 'Increases energy · Pre-workout boost',
    ),
  ];

  int _selectedIndex  = 0;
  bool _isRunning     = false;
  int _cycleCount     = 0;
  int _secondInCycle  = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(vsync: this);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  BreathingTechnique get _current => _techniques[_selectedIndex];

  String get _phaseLabel {
    if (!_isRunning) return 'Press Start';
    final s = _secondInCycle;
    if (s < _current.inhaleSeconds) return 'Inhale';
    if (s < _current.inhaleSeconds + _current.holdInSeconds) return 'Hold';
    if (s < _current.inhaleSeconds + _current.holdInSeconds +
        _current.exhaleSeconds) return 'Exhale';
    return 'Hold';
  }

  Color get _phaseColor {
    if (!_isRunning) return AppColors.textHint;
    final label = _phaseLabel;
    if (label == 'Inhale') return _current.color;
    if (label == 'Exhale') return _current.color.withOpacity(0.5);
    return AppColors.warning;
  }

  void _startStop() {
    if (_isRunning) {
      setState(() => _isRunning = false);
      _pulseController.stop();
    } else {
      setState(() {
        _isRunning    = true;
        _secondInCycle = 0;
        _cycleCount   = 0;
      });
      _runCycle();
    }
  }

  Future<void> _runCycle() async {
    if (!_isRunning || !mounted) return;

    // Animate the pulse circle for the full inhale duration
    await _pulseController.animateTo(
      1.0,
      duration: Duration(seconds: _current.inhaleSeconds),
      curve: Curves.easeIn,
    );

    // Hold
    if (_current.holdInSeconds > 0 && _isRunning && mounted) {
      await Future.delayed(
          Duration(seconds: _current.holdInSeconds));
    }

    // Exhale — shrink back
    if (_isRunning && mounted) {
      await _pulseController.animateTo(
        0.6,
        duration: Duration(seconds: _current.exhaleSeconds),
        curve: Curves.easeOut,
      );
    }

    // Hold out
    if (_current.holdOutSeconds > 0 && _isRunning && mounted) {
      await Future.delayed(
          Duration(seconds: _current.holdOutSeconds));
    }

    if (_isRunning && mounted) {
      setState(() => _cycleCount++);
      _runCycle(); // recursively runs next cycle
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Meditation & Breathing',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          // Technique selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _techniques.length,
              itemBuilder: (ctx, i) {
                final isSelected = i == _selectedIndex;
                return GestureDetector(
                  onTap: _isRunning
                      ? null
                      : () => setState(() => _selectedIndex = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _techniques[i].color
                          : AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _techniques[i].name,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Benefit text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _current.benefit,
              style: TextStyle(
                  fontSize: 12,
                  color: _current.color,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Breathing animation
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (_, __) => Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer rotating ring
                    AnimatedBuilder(
                      animation: _rotationController,
                      builder: (_, __) => Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: CustomPaint(
                          size: const Size(280, 280),
                          painter: _RingDotPainter(color: _current.color),
                        ),
                      ),
                    ),

                    // Pulsing circle
                    Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current.color.withOpacity(0.08),
                          border: Border.all(
                              color: _current.color.withOpacity(0.3),
                              width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _phaseLabel,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _phaseColor,
                              ),
                            ),
                            if (_cycleCount > 0) ...[
                              const SizedBox(height: 8),
                              Text(
                                '$_cycleCount cycles',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textHint),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _current.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          const SizedBox(height: 24),

          // Start/Stop button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startStop,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _isRunning ? AppColors.danger : _current.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _isRunning ? 'Stop session' : 'Start breathing',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// Custom painter — rotating ring of dots
class _RingDotPainter extends CustomPainter {
  final Color color;
  const _RingDotPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.4);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const dotCount = 24;

    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * math.pi;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      // Dots get smaller toward the bottom for visual variety
      final dotRadius = i % 4 == 0 ? 4.0 : 2.5;
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_RingDotPainter old) => old.color != color;
}