import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final Widget? extraWidget;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
    this.borderColor,
    this.backgroundColor,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(14),
        border: borderColor != null
            ? Border(left: BorderSide(color: borderColor!, width: 3.5))
            : Border.all(color: const Color(0xFFE8E7E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: backgroundColor == const Color(0xFF1E3A9F)
                  ? Colors.white60
                  : const Color(0xFF888888),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              if (extraWidget != null) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: extraWidget!,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
