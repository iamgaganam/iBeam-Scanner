import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onTapTab;
  final VoidBuildContextCallback? onLogout;

  const CustomAppBar({
    super.key,
    required this.currentIndex,
    required this.onTapTab,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    String titleText = 'ProxiMate';
    bool isAlerts = currentIndex == 1;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: NavigationToolbar.kMiddleSpacing,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () => onTapTab(2), // Navigate to Profile (Settings)
          child: Center(
            child: CircleAvatar(
              radius: 18,
              backgroundColor: currentIndex == 0
                  ? const Color(0xFFFFCCCC)
                  : const Color(0xFFDDDDDD),
              child: Icon(
                Icons.person,
                color: currentIndex == 0
                    ? const Color(0xFFCC6666)
                    : Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      title: isAlerts
          ? Row(
              children: const [
                Icon(
                  Icons.settings_input_antenna,
                  color: Color(0xFF1E3A9F),
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  'Alerts',
                  style: TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )
          : Text(
              titleText,
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
      centerTitle: true,
      actions: currentIndex == 1
          ? [
              const Padding(
                padding: EdgeInsets.only(right: 18),
                child: Icon(Icons.tune, color: Color(0xFF555555), size: 22),
              ),
            ]
          : currentIndex == 0
          ? [
              const Icon(
                Icons.settings_input_antenna,
                color: Color(0xFF555555),
                size: 22,
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  if (onLogout != null) {
                    onLogout!();
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                },
                child: const Icon(
                  Icons.logout,
                  color: Color(0xFF555555),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
            ]
          : [
              const Icon(
                Icons.settings_input_antenna,
                color: Color(0xFF555555),
                size: 22,
              ),
              const SizedBox(width: 16),
            ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFE8E7E3)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

typedef VoidBuildContextCallback = void Function();
