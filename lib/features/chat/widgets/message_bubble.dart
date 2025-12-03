import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alignment =
    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isCurrentUser
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.secondaryContainer.withOpacity(0.5);
    final textColor = theme.colorScheme.onSurface;

    return Container(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
            isCurrentUser ? const Radius.circular(16) : Radius.zero,
            bottomRight:
            isCurrentUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
