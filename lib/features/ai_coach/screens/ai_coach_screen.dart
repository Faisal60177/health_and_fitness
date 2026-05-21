import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/ai_coach_service.dart';
import '../providers/ai_coach_provider.dart';

class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});

  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  final _inputController  = TextEditingController();
  final _scrollController = ScrollController();
  bool _showQuickPrompts  = true;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _inputController.clear();
    setState(() => _showQuickPrompts = false);
    ref.read(aiCoachNotifierProvider.notifier).sendMessage(text);
    // Scroll to bottom after send
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiCoachNotifierProvider);

    // Auto-scroll when new messages arrive
    ref.listen(aiCoachNotifierProvider, (_, next) {
      Future.delayed(const Duration(milliseconds: 50), _scrollToBottom);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology_rounded,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Coach',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                Text(
                  state.isLoading ? 'Loading your data...' : 'Online',
                  style: TextStyle(
                    color: state.isLoading
                        ? AppColors.textHint
                        : AppColors.success,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Chat messages ──────────────────────────────────
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              itemCount: state.messages.length +
                  (_showQuickPrompts ? 1 : 0),
              itemBuilder: (ctx, i) {
                // Quick prompts row at top after first message
                if (_showQuickPrompts &&
                    i == 1) {
                  return _QuickPromptsRow(
                    onTap: _sendMessage,
                  );
                }

                final msgIndex = _showQuickPrompts && i > 1
                    ? i - 1
                    : i;
                if (msgIndex >= state.messages.length) {
                  return const SizedBox.shrink();
                }

                return _MessageBubble(
                  message: state.messages[msgIndex],
                );
              },
            ),
          ),

          // ── Error banner ───────────────────────────────────
          // ── Error banner ───────────────────────────────────
          if (state.error != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.danger.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: AppColors.danger, fontSize: 12),
                    ),
                  ),
                  // ✅ FIX 9: Retry button when service failed to init
                  if (state.service == null)
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(aiCoachNotifierProvider),
                      child: const Text('Retry',
                          style: TextStyle(color: AppColors.danger)),
                    ),
                ],
              ),
            ),

          // ── Input bar ──────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              16, 8, 16,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              border: Border(
                top: BorderSide(color: AppColors.surfaceMuted),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    maxLines: 3,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Ask your coach anything...',
                      hintStyle: const TextStyle(
                          color: AppColors.textHint, fontSize: 14),
                      filled: true,
                      fillColor: AppColors.surfaceMuted,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: state.isSending
                      ? null
                      : () => _sendMessage(_inputController.text),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: state.isSending
                          ? AppColors.surfaceMuted
                          : AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      state.isSending
                          ? Icons.hourglass_empty_rounded
                          : Icons.send_rounded,
                      color: state.isSending
                          ? AppColors.textHint
                          : Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message bubble ───────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI avatar
          if (!isUser) ...[
            Container(
              width: 28, height: 28,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology_rounded,
                  color: AppColors.primary, size: 16),
            ),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : AppColors.surfaceCard,
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(18),
                  topRight:    const Radius.circular(18),
                  bottomLeft:  Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser
                    ? null
                    : Border.all(color: AppColors.surfaceMuted),
              ),
              child: message.isStreaming && message.text.isEmpty
              // Typing indicator dots
                  ? _TypingIndicator()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser
                          ? Colors.black
                          : AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  // Blinking cursor when streaming
                  if (message.isStreaming) ...[
                    const SizedBox(height: 2),
                    _BlinkingCursor(),
                  ],
                ],
              ),
            ),
          ),

          // Spacer for user messages
          if (isUser) const SizedBox(width: 36),
        ],
      ),
    );
  }
}

// ── Typing indicator ─────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay  = i * 0.33;
            final value  = (_controller.value - delay).clamp(0.0, 1.0);
            final bounce = (value < 0.5 ? value : 1.0 - value) * 2;
            return Transform.translate(
              offset: Offset(0, -4 * bounce),
              child: Container(
                width: 6, height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color:  AppColors.textHint,
                  shape:  BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── Blinking cursor while streaming ──────────────────────────
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: Container(
        width: 2, height: 14,
        color: AppColors.primary,
      ),
    );
  }
}

// ── Quick prompt chips ───────────────────────────────────────
class _QuickPromptsRow extends StatelessWidget {
  final ValueChanged<String> onTap;
  const _QuickPromptsRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: AiCoachService.quickPrompts.map((prompt) {
          return GestureDetector(
            onTap: () => onTap(prompt),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(
                prompt,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}