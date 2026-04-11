import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool outlined;
  final Color? outlineColor;
  final Widget? customIcon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = const Color(0xFF1E3A9F),
    this.foregroundColor = Colors.white,
    this.outlined = false,
    this.outlineColor,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: 58,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: 0,
            side: BorderSide(
              color: outlineColor ?? const Color(0xFFE0DFDC),
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _buildChild(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (customIcon != null) ...[
          customIcon!,
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          Icon(icon, color: foregroundColor, size: 22),
          const SizedBox(width: 10),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
