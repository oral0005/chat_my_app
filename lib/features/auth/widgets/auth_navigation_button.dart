import 'package:flutter/material.dart';

class AuthNavigationButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;

  const AuthNavigationButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: Text(label),
    );
  }
}
