import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/app_animated_entrance.dart';
import '../../domain/entities/beacon_device.dart';
import '../bloc/beacon_scanner_bloc.dart';
import '../bloc/beacon_scanner_event.dart';
import '../bloc/beacon_scanner_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BeaconScannerBloc>().add(
        const BeaconScannerStartRequested(),
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bool isBackground = state != AppLifecycleState.resumed;
    context.read<BeaconScannerBloc>().add(
      BeaconScannerLifecycleChanged(isBackground: isBackground),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeaconScannerBloc, BeaconScannerState>(
      builder: (BuildContext context, BeaconScannerState state) {
        final List<BeaconDevice> beacons = state.beacons;

        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F5),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    AppAnimatedEntrance(
                      delay: const Duration(milliseconds: 50),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                        child: Column(
                          children: [
                            _buildRadarIcon(),
                            const SizedBox(height: 20),
                            Text(
                              _statusLabel(state),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _statusColor(state),
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Precision Scanning',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111111),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _subtitle(state),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF888888),
                                height: 1.55,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActiveNodesCard(
                                    state.activeNodes,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildRSSICard(state.strongestRssi),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    AppAnimatedEntrance(
                      delay: const Duration(milliseconds: 110),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  onTap: () {
                                    context.read<BeaconScannerBloc>().add(
                                      const BeaconScannerRefreshRequested(),
                                    );
                                  },
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

                            if (beacons.isEmpty)
                              AppAnimatedEntrance(
                                delay: const Duration(milliseconds: 180),
                                child: _buildEmptyCard(state),
                              )
                            else
                              ...beacons.asMap().entries.map((entry) {
                                return AppAnimatedEntrance(
                                  delay: Duration(
                                    milliseconds: 180 + (entry.key * 45),
                                  ),
                                  child: _buildBeaconCard(entry.value),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 24,
                right: 24,
                child: AppAnimatedEntrance(
                  delay: const Duration(milliseconds: 220),
                  beginOffset: const Offset(0, 0.08),
                  beginScale: 0.9,
                  child: GestureDetector(
                    onTap: () {
                      context.read<BeaconScannerBloc>().add(
                        const BeaconScannerStartRequested(),
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A9F),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1E3A9F,
                            ).withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadarIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E3A9F).withValues(alpha: 0.10),
                ),
              ),
            ),
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

  Widget _buildActiveNodesCard(int activeNodes) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E7E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACTIVE NODES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF888888),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$activeNodes',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A9F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRSSICard(int? strongestRssi) {
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
            children: [
              Text(
                strongestRssi?.toString() ?? '--',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const Padding(
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

  Widget _buildEmptyCard(BeaconScannerState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Text(
        state.message ??
            'No beacons detected yet. Keep the app open or run on a physical device.',
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF666666),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBeaconCard(BeaconDevice beacon) {
    final bool isCritical =
        beacon.distanceMeters > 0 && beacon.distanceMeters <= 5;
    final String distanceText = beacon.distanceMeters > 0
        ? beacon.distanceMeters.toStringAsFixed(1)
        : '--';

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        beacon.name ?? 'Beacon ${beacon.major}-${beacon.minor}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'UUID: ${_shortUuid(beacon.uuid)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
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
                          distanceText,
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
                      '${beacon.major}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
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
                      '${beacon.minor}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
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
                  const Icon(
                    Icons.bluetooth,
                    color: Color(0xFF888888),
                    size: 22,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(BeaconScannerState state) {
    switch (state.status) {
      case BeaconScreenStatus.scanning:
        return 'STATUS: ACTIVE';
      case BeaconScreenStatus.permissionDenied:
        return 'STATUS: PERMISSION REQUIRED';
      case BeaconScreenStatus.bluetoothOff:
        return 'STATUS: BLUETOOTH OFF';
      case BeaconScreenStatus.locationOff:
        return 'STATUS: LOCATION OFF';
      case BeaconScreenStatus.error:
        return 'STATUS: ERROR';
      case BeaconScreenStatus.initial:
      case BeaconScreenStatus.loading:
      case BeaconScreenStatus.stopped:
        return 'STATUS: IDLE';
    }
  }

  Color _statusColor(BeaconScannerState state) {
    switch (state.status) {
      case BeaconScreenStatus.scanning:
        return const Color(0xFF1E3A9F);
      case BeaconScreenStatus.error:
      case BeaconScreenStatus.bluetoothOff:
      case BeaconScreenStatus.locationOff:
      case BeaconScreenStatus.permissionDenied:
        return const Color(0xFFCC2222);
      case BeaconScreenStatus.initial:
      case BeaconScreenStatus.loading:
      case BeaconScreenStatus.stopped:
        return const Color(0xFF888888);
    }
  }

  String _subtitle(BeaconScannerState state) {
    if (state.message != null && state.message!.isNotEmpty) {
      return state.message!;
    }

    switch (state.status) {
      case BeaconScreenStatus.scanning:
        return 'Actively monitoring Bluetooth Low Energy\nsignals in your immediate perimeter.';
      case BeaconScreenStatus.permissionDenied:
        return 'Grant Bluetooth and Always Location\npermissions to continue scanning.';
      case BeaconScreenStatus.bluetoothOff:
        return 'Turn on Bluetooth to resume\nreal-time beacon detection.';
      case BeaconScreenStatus.locationOff:
        return 'Enable location services for\nproximity-aware background behavior.';
      case BeaconScreenStatus.error:
        return 'Scanner encountered an issue.\nTap refresh to retry.';
      case BeaconScreenStatus.initial:
      case BeaconScreenStatus.loading:
      case BeaconScreenStatus.stopped:
        return 'Scanner is ready and waiting.\nTap refresh to start ranging beacons.';
    }
  }

  String _shortUuid(String uuid) {
    if (uuid.length <= 18) {
      return uuid;
    }
    return '${uuid.substring(0, 18)}...';
  }
}
