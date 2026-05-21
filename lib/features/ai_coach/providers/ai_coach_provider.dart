import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/services/ai_coach_service.dart';
import 'package:flutter/foundation.dart';

part 'ai_coach_provider.g.dart';

class ChatMessage {
  final String text;
  final bool   isUser;
  final bool   isStreaming;
  final DateTime time;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isStreaming = false,
    required this.time,
  });

  ChatMessage copyWith({String? text, bool? isStreaming}) {
    return ChatMessage(
      text:        text        ?? this.text,
      isUser:      isUser,
      isStreaming: isStreaming ?? this.isStreaming,
      time:        time,
    );
  }
}

class AiCoachState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;
  final AiCoachService? service;

  const AiCoachState({
    this.messages  = const [],
    this.isLoading = true,
    this.isSending = false,
    this.error,
    this.service,
  });

  AiCoachState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
    bool clearError = false,   // ✅ FIX 4: explicit flag to clear error
    AiCoachService? service,
  }) {
    return AiCoachState(
      messages:  messages  ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      // clearError=true sets error to null even if null wasn't passed
      error:     clearError ? null : (error ?? this.error),
      service:   service   ?? this.service,
    );
  }
}

@riverpod
class AiCoachNotifier extends _$AiCoachNotifier {
  @override
  AiCoachState build() {
    Future.microtask(_initService);

    return AiCoachState(
      messages: [
        ChatMessage(
          text:   "Hi! I'm your personal health coach. I can see your stats for today. "
              "What would you like to work on?",
          isUser: false,
          time:   DateTime.now(),
        ),
      ],
    );
  }

  Future<void> _initService() async {
    try {
      final service = await AiCoachService.create();
      state = state.copyWith(
        service:    service,
        isLoading:  false,
        clearError: true,
      );
    } catch (e) {
      // ✅ FIX 5: Show the actual init error to help debugging
      debugPrint('🔴 AiCoachService init error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Could not start AI coach: ${e.toString()}',
      );
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    if (state.isSending) return;

    // ✅ FIX 6: Don't silently return — show error if service isn't ready
    if (state.service == null) {
      state = state.copyWith(
        error: 'AI coach is not ready yet. Please wait a moment.',
      );
      return;
    }

    // Clear any previous error when user sends a new message
    final userMsg = ChatMessage(
      text:   text.trim(),
      isUser: true,
      time:   DateTime.now(),
    );

    final aiPlaceholder = ChatMessage(
      text:        '',
      isUser:      false,
      isStreaming: true,
      time:        DateTime.now(),
    );

    state = state.copyWith(
      messages:   [...state.messages, userMsg, aiPlaceholder],
      isSending:  true,
      clearError: true,   // ✅ FIX 7: Clear old errors on each new send
    );

    String accumulated = '';

    try {
      await for (final chunk
      in state.service!.sendMessageStream(text.trim())) {
        accumulated += chunk;
        final updated = List<ChatMessage>.from(state.messages);
        updated[updated.length - 1] =
            aiPlaceholder.copyWith(text: accumulated, isStreaming: true);
        state = state.copyWith(messages: updated);
      }
    } catch (e) {
      // ✅ FIX 8: Catch stream-level errors that bypass sendMessageStream's try/catch
      debugPrint('🔴 Stream error in sendMessage: $e');
      accumulated = 'Something went wrong. Please try again.';
    }

    // Finalise the last message
    final finalMessages = List<ChatMessage>.from(state.messages);
    finalMessages[finalMessages.length - 1] =
        aiPlaceholder.copyWith(text: accumulated, isStreaming: false);

    state = state.copyWith(
      messages:  finalMessages,
      isSending: false,
    );
  }
}