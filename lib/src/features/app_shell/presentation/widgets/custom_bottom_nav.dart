import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8E7E3))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.my_location_outlined,
              activeIcon: Icons.my_location,
              label: 'SCAN',
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.notifications_none,
              activeIcon: Icons.notifications,
              label: 'ALERTS',
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E3A9F) : Colors.transparent,
          borderRadius: BorderRadius.circular(
            14,
          ), // Gives a nice square/slightly rectangular shape
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  scale: isActive ? 1.08 : 1,
                  child: Icon(
                    isActive ? activeIcon : icon,
                    color: isActive ? Colors.white : const Color(0xFF888888),
                    size: 22,
                  ),
                ),
                if (label == 'ALERTS' && !isActive)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF888888),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
