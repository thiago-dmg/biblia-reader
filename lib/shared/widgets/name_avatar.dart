import 'package:flutter/material.dart';

/// Avatar com foto (URL) ou iniciais do nome — estilo rede social.
class NameAvatar extends StatelessWidget {
  const NameAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.radius = 22,
  });

  final String name;
  final String? photoUrl;
  final double radius;

  static String initials(String name) {
    final t = name.trim();
    if (t.isEmpty) return '?';
    final parts = t.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return t.length >= 2 ? t.substring(0, 2).toUpperCase() : t[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = photoUrl?.trim();
    final size = radius * 2;
    if (url != null && url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _fallback(context, scheme, size),
        ),
      );
    }
    return _fallback(context, scheme, size);
  }

  Widget _fallback(BuildContext context, ColorScheme scheme, double size) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primary.withValues(alpha: 0.12),
      child: Text(
        initials(name),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
