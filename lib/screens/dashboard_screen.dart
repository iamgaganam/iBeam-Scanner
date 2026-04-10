import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _beacons = [
    {
      'name': 'Conference Room B',
      'uuid': '550E8400-E29B-41D4...',
      'majorId': '1002',
      'minorId': '45',
      'distance': '4.1',
      'critical': true,
      'icon': Icons.location_on,
      'iconColor': Color(0xFFFFAA00),
    },
    {
      'name': 'Asset Tag: #A882',
      'uuid': 'B12F6710-C90A-33B2...',
      'majorId': '501',
      'minorId': '8',
      'distance': '7.2',
      'critical': false,
      'icon': Icons.bluetooth_disabled,
      'iconColor': Color(0xFF888888),
    },
    {
      'name': 'Server Hall 4 Gateway',
      'uuid': '2A123C40-991A-4F11...',
      'majorId': '200',
      'minorId': '124',
      'distance': '15.8',
      'critical': false,
      'icon': Icons.print_outlined,
      'iconColor': Color(0xFF888888),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFFFCCCC),
            child: const Icon(Icons.person, color: Color(0xFFCC6666), size: 20),
          ),
        ),
        title: const Text(
          'Proximity Aware',
          style: TextStyle(
            color: Color(0xFF111111),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          const Icon(
            Icons.settings_input_antenna,
            color: Color(0xFF555555),
            size: 22,
          ),
          const SizedBox(width: 16),
          const Icon(Icons.logout, color: Color(0xFF555555), size: 22),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE8E7E3)),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                // Top Hero Section
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                  child: Column(
                    children: [
                      // Animated Radar Icon
                      _buildRadarIcon(),
                      const SizedBox(height: 20),
                      // Status label
                      const Text(
                        'STATUS: ACTIVE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E3A9F),
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      const Text(
                        'Precision Scanning',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Subtitle
                      const Text(
                        'Actively monitoring Bluetooth Low Energy\nsignals in your immediate perimeter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Stats Row
                      Row(
                        children: [
                          Expanded(child: _buildActiveNodesCard()),
                          const SizedBox(width: 14),
                          Expanded(child: _buildRSSICard()),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Detected Beacons Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detected Beacons',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111111),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Nearby localized identifiers',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: const Row(
                              children: [
                                Text(
                                  'REFRESH',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E3A9F),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.refresh,
                                  color: Color(0xFF1E3A9F),
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Beacon Cards
                      ..._beacons
                          .map((beacon) => _buildBeaconCard(beacon))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FAB
          Positioned(
            bottom: 90,
            right: 20,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A9F),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A9F).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildRadarIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E3A9F).withOpacity(0.10),
                ),
              ),
            ),
            // Inner navy circle
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1E3A9F),
              ),
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActiveNodesCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E7E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'ACTIVE NODES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF888888),
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '12',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A9F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRSSICard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A9F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STRONGEST RSSI',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white60,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                '-42',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 4),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'dBm',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeaconCard(Map<String, dynamic> beacon) {
    final bool isCritical = beacon['critical'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCritical
            ? const Border(left: BorderSide(color: Color(0xFFFFAA00), width: 4))
            : Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(isCritical ? 14 : 18, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + UUID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        beacon['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'UUID: ${beacon['uuid']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
                // Distance + Critical badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'DISTANCE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF888888),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          beacon['distance'],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isCritical
                                ? const Color(0xFFFFAA00)
                                : const Color(0xFF111111),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5, left: 2),
                          child: Text(
                            'm',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Major ID
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MAJOR ID',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF888888),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      beacon['majorId'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // Minor ID
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MINOR ID',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF888888),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      beacon['minorId'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Critical badge or device icon
                if (isCritical)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'CRITICAL\nPROXIMITY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF996600),
                        letterSpacing: 0.5,
                        height: 1.4,
                      ),
                    ),
                  )
                else
                  Icon(beacon['icon'], color: beacon['iconColor'], size: 22),
              ],
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
          // SCAN - active
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
                      Icon(Icons.my_location, color: Colors.white, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'SCAN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ALERTS
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF888888),
                      size: 24,
                    ),
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
                const Text(
                  'ALERTS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                    letterSpacing: 0.8,
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
                  'PROFILE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                    letterSpacing: 0.8,
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
