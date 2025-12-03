import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;

  const AuthButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
