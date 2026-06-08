import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../repositories/step_repository.dart';
import '../repositories/weight_repository.dart';
import '../repositories/sleep_repository.dart';
import '../repositories/food_repository.dart';
import '../repositories/workout_repository.dart';

class AiCoachService {
  // ⚠️ Replace with your NEW key from aistudio.google.com
  // Never commit this to GitHub!
  static const _apiKey = 'AIzaSyCYTZCv2fxwNLyfZM2OQdCiINyqwJ943Yc';

  late final GenerativeModel _model;
  late final ChatSession _chat;

  String _buildSystemPrompt({
    required int todaySteps,
    required double? latestWeightKg,
    required double? lastSleepHours,
    required double todayCalories,
    required int workoutsThisWeek,
  }) {
    // Calculate step progress percentage
    final stepPercent = ((todaySteps / 10000) * 100).clamp(0, 100).toStringAsFixed(0);

    return '''
You are an expert personal health and fitness coach built into a mobile app.
Your name is Coach. You are warm, motivating, intelligent, and sound like a real human coach — not a robot or generic AI.

PERSONALITY:
- Encouraging and positive, but honest when the user needs to improve
- Use the user's real data to make every response feel personal
- Speak naturally, like a knowledgeable friend who happens to be a fitness expert
- Use light emoji occasionally to feel friendly (e.g. 💪 🔥 ✅ 😴 🥗)

RESPONSE RULES:
- Short questions (greetings, motivation, simple advice): 2–4 sentences, warm and direct
- Progress/tracking questions: reference the user's ACTUAL numbers, give honest assessment
- Detailed requests (workout plans, meal plans, explanations): give a complete, well-structured response with numbered steps or bullet points
- ALWAYS complete your full thought — never cut off mid-sentence or mid-list
- Never say "As an AI" or "I'm just a language model" — you are their coach
- Never give medical diagnoses — say "check with your doctor" for medical concerns

USER'S LIVE DATA RIGHT NOW:
- Steps today: $todaySteps / 10,000 (${stepPercent}% of goal)
- Current weight: ${latestWeightKg != null ? '${latestWeightKg.toStringAsFixed(1)} kg' : 'not logged yet — remind them to log it'}
- Last night\'s sleep: ${lastSleepHours != null ? '${lastSleepHours.toStringAsFixed(1)} hours' : 'not logged yet — remind them to log it'}
- Calories consumed today: ${todayCalories.toStringAsFixed(0)} kcal
- Workouts completed this week: $workoutsThisWeek

ALWAYS use this data when answering. For example:
- If steps < 5000: acknowledge they're behind and suggest a quick walk
- If steps > 8000: celebrate their progress
- If sleep < 6 hours: flag that recovery is important
- If calories = 0: ask if they've forgotten to log food
- If workouts = 0: gently encourage them to start
''';
  }

  AiCoachService._();

  static Future<AiCoachService> create() async {
    final service = AiCoachService._();
    await service._initialize();
    return service;
  }

  Future<void> _initialize() async {
    final stepEntry      = await StepRepository().getTodayEntry();
    final weightLog      = await WeightRepository().getLatest();
    final sleepLogs      = await SleepRepository().getRecentNights(1);
    final foodSummary    = await FoodRepository().getTodaySummary();
    final weeklyWorkouts = await WorkoutRepository().getAllSessions();

    final systemPrompt = _buildSystemPrompt(
      todaySteps:       stepEntry?.stepCount ?? 0,
      latestWeightKg:   weightLog?.weightKg,
      lastSleepHours:   sleepLogs.isEmpty ? null : sleepLogs.first.durationHours,
      todayCalories:    (foodSummary['calories'] ?? 0).toDouble(),
      workoutsThisWeek: weeklyWorkouts.length,
    );

    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: _apiKey,
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        temperature:     0.8,   // slightly creative = more natural/human tone
        maxOutputTokens: 800,   // enough for detailed answers, won't cut off
        topP:            0.95,
        topK:            40,
      ),
    );

    // Opening greeting seeds the conversation naturally
    _chat = _model.startChat(history: [
      Content.model([TextPart(
        "Hey! 👋 I'm your personal health coach. I've already loaded your stats for today — "
            "I'm here whenever you need advice, motivation, or a plan. What would you like to work on?",
      )]),
    ]);
  }

  Stream<String> sendMessageStream(String userMessage) async* {
    try {
      final response = _chat.sendMessageStream(
        Content.text(userMessage),
      );

      await for (final chunk in response) {
        final text = chunk.text;
        if (text != null && text.isNotEmpty) {
          yield text;
        }
      }
    } catch (e) {
      debugPrint('🔴 Gemini API error: $e');

      final error = e.toString();

      if (error.contains('quota') || error.contains('429')) {
        yield "I've hit my message limit for now — please try again in a minute! ⏳";
      } else if (error.contains('API_KEY') || error.contains('api key')) {
        yield 'There\'s an issue with the API key. Please contact support.';
      } else if (error.contains('not found') || error.contains('404')) {
        yield 'The AI model is temporarily unavailable. Please try again shortly.';
      } else if (error.contains('network') || error.contains('socket')) {
        yield 'No internet connection. Please check your network and try again. 📶';
      } else {
        yield 'Something went wrong. Please try again! (${e.toString()})';
      }
    }
  }

  static const List<String> quickPrompts = [
    'How am I doing today?',
    'What should I eat for lunch?',
    'Give me a quick workout',
    'How can I sleep better?',
    'Am I on track this week?',
    'Motivate me! 💪',
  ];
}



