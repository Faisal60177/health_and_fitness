import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiExercise {
  final int    id;
  final String name;
  final String description;
  final String category;
  final String equipment;
  final List<String> muscles;
  final List<String> musclesSecondary;
  final String gifUrl;

  const ApiExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.equipment,
    required this.muscles,
    required this.musclesSecondary,
    required this.gifUrl,
  });

  factory ApiExercise.fromJson(Map<String, dynamic> json) {
    // Open-source ExerciseDB structure:
    // {
    //   "id": "0001",
    //   "name": "3/4 sit-up",
    //   "bodyPart": "waist",
    //   "equipment": "body weight",
    //   "target": "abs",
    //   "secondaryMuscles": ["hip flexors"],
    //   "instructions": ["step 1", "step 2"],
    //   "gifUrl": "https://raw.githubusercontent.com/..."  ← PUBLIC
    // }

    final rawInstructions = json['instructions'];
    final List<String> instructions;

    if (rawInstructions is List) {
      instructions = rawInstructions.map((s) => s.toString()).toList();
    } else if (rawInstructions is String) {
      instructions = [rawInstructions];
    } else {
      instructions = [];
    }

    final description = instructions.isNotEmpty
        ? instructions
        .asMap()
        .entries
        .map((e) => '${e.key + 1}. ${e.value}')
        .join('\n')
        : '';

    return ApiExercise(
      id:       int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name:     _capitalize(json['name']?.toString() ?? ''),
      description: description,
      category:    _capitalize(json['bodyPart']?.toString() ?? 'General'),
      equipment:   _capitalize(json['equipment']?.toString() ?? 'No equipment'),
      muscles: [_capitalize(json['target']?.toString() ?? '')]
          .where((s) => s.isNotEmpty)
          .toList(),
      musclesSecondary: (json['secondaryMuscles'] as List<dynamic>?)
          ?.map((m) => _capitalize(m.toString()))
          .toList() ??
          [],
      // GitHub raw URLs — fully public, no auth needed
      gifUrl: json['gifUrl']?.toString() ?? '',
    );
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s.split(' ').map((w) {
      if (w.isEmpty) return w;
      return '${w[0].toUpperCase()}${w.substring(1)}';
    }).join(' ');
  }
}

class ExerciseApiService {
  // Open-source ExerciseDB — no API key, no rate limits, public GIFs
  // Source: https://github.com/wrkout/exercises.json
  static const _base = 'https://exercisedb-api.vercel.app/api/v1';

  // ── Fetch exercises by body part ─────────────────────────
  static Future<List<ApiExercise>> fetchExercises({
    int     limit      = 20,
    int     offset     = 0,
    String? category,
    String? equipment,
    String  searchTerm = '',
  }) async {
    String url;

    if (category != null) {
      final bodyPart = categoryMap[category] ?? 'back';
      final encoded  = Uri.encodeComponent(bodyPart);
      url = '$_base/exercises/bodyPart/$encoded?limit=$limit&offset=$offset';
    } else if (equipment != null) {
      final equip   = equipmentMap[equipment] ?? 'body weight';
      final encoded = Uri.encodeComponent(equip);
      url = '$_base/exercises/equipment/$encoded?limit=$limit&offset=$offset';
    } else {
      url = '$_base/exercises?limit=$limit&offset=$offset';
    }

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('API error ${response.statusCode}');
      }

      // Open-source ExerciseDB wraps results in { data: [...] }
      final decoded = jsonDecode(response.body);
      final List<dynamic> data;

      if (decoded is Map && decoded.containsKey('data')) {
        data = decoded['data'] as List<dynamic>;
      } else if (decoded is List) {
        data = decoded;
      } else {
        data = [];
      }

      var exercises = data
          .map((j) => ApiExercise.fromJson(j as Map<String, dynamic>))
          .where((e) => e.name.isNotEmpty)
          .toList();

      if (searchTerm.isNotEmpty) {
        final q = searchTerm.toLowerCase();
        exercises = exercises
            .where((e) =>
        e.name.toLowerCase().contains(q) ||
            e.category.toLowerCase().contains(q) ||
            e.equipment.toLowerCase().contains(q) ||
            e.muscles.any((m) => m.toLowerCase().contains(q)))
            .toList();
      }

      return exercises;
    } catch (e) {
      // Return empty — ExerciseRepository falls back to Isar cache
      return [];
    }
  }

  // ── Search by name ────────────────────────────────────────
  static Future<List<ApiExercise>> searchExercises(String query) async {
    if (query.length < 2) return [];

    try {
      final encoded  = Uri.encodeComponent(query.toLowerCase());
      final response = await http
          .get(Uri.parse('$_base/exercises/name/$encoded?limit=20'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final decoded = jsonDecode(response.body);
      final List<dynamic> data;

      if (decoded is Map && decoded.containsKey('data')) {
        data = decoded['data'] as List<dynamic>;
      } else if (decoded is List) {
        data = decoded;
      } else {
        data = [];
      }

      return data
          .map((j) => ApiExercise.fromJson(j as Map<String, dynamic>))
          .where((e) => e.name.isNotEmpty)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ── Fetch single exercise by ID ───────────────────────────
  static Future<ApiExercise?> fetchById(String exerciseId) async {
    try {
      final response = await http
          .get(Uri.parse('$_base/exercises/exercise/$exerciseId'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body);
      final Map<String, dynamic> data;

      if (decoded is Map && decoded.containsKey('data')) {
        data = decoded['data'] as Map<String, dynamic>;
      } else {
        data = decoded as Map<String, dynamic>;
      }

      return ApiExercise.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  // Kept for interface compatibility
  static Future<String> fetchExerciseImageUrl(int exerciseId) async => '';

  // ── Category maps ─────────────────────────────────────────
  static const categoryMap = {
    '10': 'waist',
    '8':  'upper arms',
    '12': 'back',
    '14': 'lower legs',
    '11': 'chest',
    '9':  'upper legs',
    '13': 'shoulders',
    '15': 'cardio',
    '16': 'neck',
  };

  static const categoryDisplayMap = {
    '10': 'Abs',
    '8':  'Arms',
    '12': 'Back',
    '14': 'Calves',
    '11': 'Chest',
    '9':  'Legs',
    '13': 'Shoulders',
    '15': 'Cardio',
    '16': 'Neck',
  };

  static const equipmentMap = {
    '1':  'barbell',
    '3':  'dumbbell',
    '4':  'body weight',
    '8':  'ez barbell',
    '10': 'kettlebell',
    '7':  'body weight',
  };
}