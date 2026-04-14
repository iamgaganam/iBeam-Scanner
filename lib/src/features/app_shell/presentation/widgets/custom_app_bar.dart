import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/user_profile_avatar.dart';
import '../../../../app/routes/app_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final String userId;
  final Function(int) onTapTab;
  final VoidBuildContextCallback? onLogout;

  const CustomAppBar({
    super.key,
    required this.currentIndex,
    required this.userId,
    required this.onTapTab,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    String titleText = 'Proximity Aware';
    bool isAlerts = currentIndex == 1;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: isAlerts ? 0 : 64,
      titleSpacing: NavigationToolbar.kMiddleSpacing,
      leading: isAlerts
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: () => onTapTab(2),
                child: Center(
                  child: UserProfileAvatar(
                    userId: userId,
                    radius: 18,
                    iconSize: 20,
                  ),
                ),
              ),
            ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.06, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: isAlerts
            ? Row(
                key: const ValueKey<String>('alerts_title'),
                children: const [
                  Icon(
                    Icons.settings_input_antenna,
                    color: Color(0xFF1E3A9F),
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Alerts',
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            : Text(
                titleText,
                key: const ValueKey<String>('default_title'),
                style: const TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
      centerTitle: false,
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
