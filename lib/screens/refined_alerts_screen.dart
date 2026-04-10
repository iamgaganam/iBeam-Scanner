import 'package:flutter/material.dart';

class RefinedAlertsScreen extends StatelessWidget {
  const RefinedAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
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
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Icon(Icons.tune, color: Color(0xFF555555), size: 22),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE8E7E3)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          children: [
            // Stats Row
            _buildStatsRow(),
            const SizedBox(height: 20),

            // Alert Cards
            _buildAlertCard(
              tag: 'BACKGROUND_DETECTION',
              title: 'New Beacon Found',
              description:
                  "You are near 'Conference Room B'. Open the app for details and automated room check-in.",
              tagIcon: Icons.my_location,
              tagIconBg: const Color(0xFFEEF0F8),
              tagIconColor: const Color(0xFF1E3A9F),
              leftBorderColor: const Color(0xFF1E3A9F),
              metricLabel: 'CURRENT DISTANCE',
              metricValue: '8.5m',
              metricValueColor: const Color(0xFF1E3A9F),
              threshold: 'Threshold: 10.0m',
              uuid: 'E2C56DB5-DFFB-48D2-B868-D0F5A71996E8',
              buttonLabel: 'Open App',
              buttonColor: const Color(0xFF1E3A9F),
              buttonTextColor: Colors.white,
            ),
            const SizedBox(height: 14),

            _buildAlertCard(
              tag: 'PROXIMITY_THRESHOLD',
              title: 'Proximity Alert',
              description:
                  'Welcome! You are now within 5 meters of the beacon. High precision location tracking is active.',
              tagIcon: Icons.warning_amber_rounded,
              tagIconBg: const Color(0xFFFFF8E1),
              tagIconColor: const Color(0xFFFFAA00),
              leftBorderColor: const Color(0xFFFFAA00),
              metricLabel: 'CURRENT DISTANCE',
              metricValue: '4.8m',
              metricValueColor: const Color(0xFFFFAA00),
              threshold: 'Threshold: 5.0m',
              uuid: 'D4B56DB5-AFFB-48D2-A060-B0F5A71996E1',
              buttonLabel: 'View Details',
              buttonColor: const Color(0xFFFFAA00),
              buttonTextColor: Colors.white,
            ),
            const SizedBox(height: 14),

            _buildAlertCard(
              tag: 'IMMEDIATE_PROXIMITY',
              title: 'Touchpoint Reached',
              description:
                  "You are standing directly at 'Private Office 4'. Tap to check-in for your scheduled meeting.",
              tagIcon: Icons.check_circle,
              tagIconBg: const Color(0xFFE8F8F0),
              tagIconColor: const Color(0xFF2AAA6A),
              leftBorderColor: const Color(0xFF2AAA6A),
              metricLabel: 'CURRENT DISTANCE',
              metricValue: '0.2m',
              metricValueColor: const Color(0xFF2AAA6A),
              threshold: 'Threshold: 1.0m',
              uuid: 'A3221188-3344-48C2-A001-EE203344CC89',
              buttonLabel: 'Auto Check-in',
              buttonColor: const Color(0xFF2AAA6A),
              buttonTextColor: Colors.white,
            ),
            const SizedBox(height: 14),

            _buildAlertCard(
              tag: 'SIGNAL_LOST',
              title: 'Connection Dropped',
              description:
                  "Signal for 'West Wing Lobby' has been lost due to interference. System has been marked as inactive.",
              tagIcon: Icons.signal_wifi_off,
              tagIconBg: const Color(0xFFFFEEEE),
              tagIconColor: const Color(0xFFCC2222),
              leftBorderColor: const Color(0xFFCC2222),
              metricLabel: 'LAST SEEN',
              metricValue: '—',
              metricValueColor: const Color(0xFF111111),
              threshold: 'Threshold: 15.0m',
              uuid: 'C3C56DB5-EEDF-48D2-A060-D0F5A71996F5',
              buttonLabel: 'Retry Connection',
              buttonColor: const Color(0xFFCC2222),
              buttonTextColor: Colors.white,
            ),
            const SizedBox(height: 14),

            _buildAlertCard(
              tag: 'HARDWARE_ERROR',
              title: 'Bluetooth Disabled',
              description:
                  'Scanning has stopped because Bluetooth was turned off mid-scan. Please enable it to resume.',
              tagIcon: Icons.bluetooth_disabled,
              tagIconBg: const Color(0xFFFFEEEE),
              tagIconColor: const Color(0xFFCC2222),
              leftBorderColor: const Color(0xFFCC2222),
              metricLabel: 'STATUS',
              metricValue: 'OFF',
              metricValueColor: const Color(0xFFCC2222),
              threshold: 'Hardware ID: BT_01',
              uuid: 'SYSTEM_PAYLOAD: ERROR_BT_404',
              buttonLabel: 'Open Settings',
              buttonColor: const Color(0xFFF0EFEB),
              buttonTextColor: const Color(0xFF444444),
            ),
            const SizedBox(height: 14),

            _buildAlertCard(
              tag: 'PERMISSION_DENIED',
              title: 'Location Access',
              description:
                  "Background scanning requires 'Always Allow' location permissions for beacon detection to function.",
              tagIcon: Icons.location_off,
              tagIconBg: const Color(0xFFFFF8E1),
              tagIconColor: const Color(0xFFFFAA00),
              leftBorderColor: const Color(0xFFFFAA00),
              metricLabel: 'PERMISSION',
              metricValue: 'DENIED',
              metricValueColor: const Color(0xFFFFAA00),
              threshold: 'Requirement: Always',
              uuid: 'PERM_ID: IOS_LOCATION_ALWAYS_ALLOW',
              buttonLabel: 'Grant Access',
              buttonColor: const Color(0xFFFFAA00),
              buttonTextColor: Colors.white,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          // Active Scans
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: const Border(
                  left: BorderSide(color: Color(0xFF1E3A9F), width: 3.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ACTIVE SCANS',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF888888),
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '12',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Nearby Beacons
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: const Border(
                  left: BorderSide(color: Color(0xFFFFAA00), width: 3.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'NEARBY BEACONS',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF888888),
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '04',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required String tag,
    required String title,
    required String description,
    required IconData tagIcon,
    required Color tagIconBg,
    required Color tagIconColor,
    required Color leftBorderColor,
    required String metricLabel,
    required String metricValue,
    required Color metricValueColor,
    required String threshold,
    required String uuid,
    required String buttonLabel,
    required Color buttonColor,
    required Color buttonTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: leftBorderColor, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag row
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: tagIconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tagIcon, color: tagIconColor, size: 18),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF888888),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF555555),
                height: 1.55,
              ),
            ),
            const SizedBox(height: 14),

            // Metric row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEEEEEA)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metricLabel,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF888888),
                          letterSpacing: 0.9,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        metricValue,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: metricValueColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    threshold,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // UUID row
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEEEEEA)),
              ),
              child: Text(
                'UUID: $uuid',
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: Color(0xFF888888),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Action button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: buttonTextColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: buttonTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8E7E3))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // SCAN
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.my_location_outlined,
                  color: Color(0xFF888888),
                  size: 24,
                ),
                SizedBox(height: 4),
                Text(
                  'Scan',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          // ALERTS - active
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A9F),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications, color: Colors.white, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Alerts',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // PROFILE
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.person_outline, color: Color(0xFF888888), size: 24),
                SizedBox(height: 4),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
