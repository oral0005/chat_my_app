import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
