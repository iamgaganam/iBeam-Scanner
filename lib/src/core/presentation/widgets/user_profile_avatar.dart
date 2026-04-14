import 'package:flutter/material.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({
    super.key,
    required this.userId,
    this.radius = 20,
    this.iconSize = 24,
  });

  final String userId;
  final double radius;
  final double iconSize;

  static Color colorFor(String userId) {
    final List<Color> colors = const <Color>[
      Color(0xFF5BBDBD),
      Color(0xFF6C63FF),
      Color(0xFFFF6B6B),
      Color(0xFF4ECDC4),
      Color(0xFFFFD93D),
      Color(0xFF6BCB77),
      Color(0xFF4D96FF),
      Color(0xFFFF8C42),
      Color(0xFFA8DADC),
      Color(0xFF457B9D),
      Color(0xFFE63946),
      Color(0xFF2A9D8F),
      Color(0xFFE76F51),
      Color(0xFFF4A261),
      Color(0xFF2E8B57),
    ];

    int hash = 0;
    for (int i = 0; i < userId.length; i++) {
      hash = ((hash << 5) - hash) + userId.codeUnitAt(i);
      hash = hash & hash;
    }

    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: colorFor(userId),
      child: Icon(Icons.person, size: iconSize, color: Colors.white),
    );
  }
}
