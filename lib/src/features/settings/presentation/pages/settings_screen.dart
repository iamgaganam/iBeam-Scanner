import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/stat_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // White top section
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: Column(
                children: [
                  // Avatar with gold ring and shield badge
                  _buildAvatar(),
                  const SizedBox(height: 16),
                  // Name
                  const Text(
                    'Marcus Sterling',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  const Text(
                    'm.sterling@proximity-aware.io',
                    style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                  ),
                  const SizedBox(height: 24),
                  // Stats Row
                  Row(
                    children: [
                      const Expanded(
                        child: StatCard(
                          label: 'ACTIVE NODES',
                          value: '12',
                          valueColor: Color(0xFF1E3A9F),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: StatCard(
                          label: 'SIGNAL HEALTH',
                          value: '98%',
                          valueColor: Color(0xFF8B6F00),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Configuration Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONFIGURATION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF888888),
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Config Cards
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE8E7E3)),
                    ),
                    child: Column(
                      children: [
                        _buildConfigItem(
                          icon: Icons.notifications_active_outlined,
                          title: 'Notification Preferences',
                          subtitle: 'Manage proximity alerts and system logs',
                          isFirst: true,
                        ),
                        _buildDivider(),
                        _buildConfigItem(
                          icon: Icons.wifi_tethering,
                          title: 'iBeacon Protocol Specs',
                          subtitle: 'UUID, Major, and Minor broadcast settings',
                        ),
                        _buildDivider(),
                        _buildConfigItem(
                          icon: Icons.bar_chart_outlined,
                          title: 'Distance Algorithm Explanation',
                          subtitle: 'RSSI path loss model and trilateration',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Background Scan Active Banner
                  _buildScanBanner(),

                  const SizedBox(height: 16),

                  // Sign Out Button
                  CustomButton(
                    label: 'Sign Out',
                    icon: Icons.logout,
                    backgroundColor: const Color(0xFFFFEDED),
                    foregroundColor: const Color(0xFFCC2222),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Version
                  const Center(
                    child: Text(
                      'VERSION 4.2.0-STABLE',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFAAAAAA),
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Gold gradient ring
        Container(
          width: 94,
          height: 94,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const SweepGradient(
              colors: [
                Color(0xFFB8860B),
                Color(0xFFDAA520),
                Color(0xFF8B6914),
                Color(0xFFDAA520),
              ],
            ),
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: const Color(0xFF5BBDBD),
              child: ClipOval(
                child: Icon(Icons.person, size: 56, color: Colors.white),
              ),
            ),
          ),
        ),
        // Shield badge
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A9F),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfigItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1E3A9F), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 20),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 72),
      height: 1,
      color: const Color(0xFFF0EFEB),
    );
  }

  Widget _buildScanBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC107),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.my_location, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'BACKGROUND SCAN ACTIVE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7A5500),
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Precision Tracking: 0.2m variance',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A3200),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
