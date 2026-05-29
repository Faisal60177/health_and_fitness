import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/services/isar_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/services/notification_service.dart';
import 'data/services/step_foreground_service.dart';
import 'data/repositories/step_repository.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'data/repositories/auth_repository.dart';

void _onReceiveStepData(Object data) async {
  if (data is! Map) return;
  final map = Map<String, dynamic>.from(data as Map);
  final steps = (map['healthSteps'] ?? map['steps']) as int?;
  if (steps == null || steps <= 0) return;
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await StepRepository().saveTodaySteps(steps);
    }
  } catch (e) {
    debugPrint('Step save error: $e');
  }
}

void main() async{

  // WidgetsFlutterBinding.ensureInitialized() is required before
  // any async work happens before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Open the Isar database before the UI launches
  await IsarService.initialize();
  await Firebase.initializeApp(             // NEW
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthRepository.initializeGoogleSignIn(
    webClientId: '1099427515724-b1mj1hiv1g1ubipknvn4rqmhohcgl614.apps.googleusercontent.com',
  );

  await NotificationService.initialize();
  await StepForegroundService.initialize();
  FlutterForegroundTask.addTaskDataCallback(_onReceiveStepData);

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await StepForegroundService.start();
  }

  runApp(
    const ProviderScope(
      child: HealthApp(),
    ),
  );
}