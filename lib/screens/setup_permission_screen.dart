import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class SetupPermissionScreen extends StatefulWidget {
  const SetupPermissionScreen({super.key});

  @override
  State<SetupPermissionScreen> createState() => _SetupPermissionScreenState();
}

class _SetupPermissionScreenState extends State<SetupPermissionScreen> {
  bool _locationEnabled = true;
  bool _bluetoothEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F1EF),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.arrow_back, color: Color(0xFF1E3A9F), size: 24),
          ),
        ),
        title: const Text(
          'Setup',
          style: TextStyle(
            color: Color(0xFF111111),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 4,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),

                    // Radar Icon Card
                    _buildRadarCard(),

                    const SizedBox(height: 40),

                    // Title
                    const Text(
                      'Precision is key',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Subtitle
                    const Text(
                      'To accurately detect proximity and keep your environment secure, we need a few keys to the kingdom.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF888888),
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Location Toggle
                    _buildToggleCard(
                      title: 'Enable Location Services (Always)',
                      subtitle: 'Required for background awareness',
                      value: _locationEnabled,
                      onChanged: (val) =>
                          setState(() => _locationEnabled = val),
                    ),

                    const SizedBox(height: 12),

                    // Bluetooth Toggle
                    _buildToggleCard(
                      title: 'Enable Bluetooth Scan',
                      subtitle: 'Detects nearby trusted devices',
                      value: _bluetoothEnabled,
                      onChanged: (val) =>
                          setState(() => _bluetoothEnabled = val),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Column(
                children: [
                  // Grant Permissions Button
                  CustomButton(
                    label: 'Grant Permissions',
                    backgroundColor: const Color(0xFF1E3A9F),
                    foregroundColor: Colors.white,
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/main',
                        (route) => false,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Encrypted label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.lock_outline,
                        size: 13,
                        color: Color(0xFFAAAAAA),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'DATA IS ENCRYPTED AND STORED LOCALLY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFAAAAAA),
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarCard() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 110,
          height: 110,
          child: CustomPaint(painter: _RadarIconPainter()),
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E7E3), width: 1),
      ),
      child: Row(
        children: [
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF1E3A9F),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCCCCCC),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }
}

class _RadarIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const navyColor = Color(0xFF1E3A9F);
    const lightCircleColor = Color(0xFFD0D4E8);

    // Outer light circle
    final outerPaint = Paint()
      ..color = lightCircleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, size.width * 0.48, outerPaint);

    // Middle navy circle
    final midPaint = Paint()
      ..color = navyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, size.width * 0.33, midPaint);

    // Inner navy circle (filled slightly)
    final innerPaint = Paint()
      ..color = navyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, size.width * 0.18, innerPaint);

    // Location pin dot at center
    final dotPaint = Paint()
      ..color = navyColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.055, dotPaint);

    // Diagonal line (like a search/scan indicator)
    final linePaint = Paint()
      ..color = navyColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx + size.width * 0.14, center.dy + size.width * 0.14),
      Offset(center.dx + size.width * 0.38, center.dy + size.width * 0.38),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
