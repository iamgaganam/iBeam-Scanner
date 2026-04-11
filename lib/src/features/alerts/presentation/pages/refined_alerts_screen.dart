import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/proximity_alert.dart';
import '../bloc/alerts_bloc.dart';
import '../bloc/alerts_event.dart';
import '../bloc/alerts_state.dart';

class RefinedAlertsScreen extends StatefulWidget {
  const RefinedAlertsScreen({super.key});

  @override
  State<RefinedAlertsScreen> createState() => _RefinedAlertsScreenState();
}

class _RefinedAlertsScreenState extends State<RefinedAlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertsBloc>().add(const AlertsRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EF),
      body: BlocBuilder<AlertsBloc, AlertsState>(
        builder: (BuildContext context, AlertsState state) {
          if (state is AlertLoading || state is AlertInitial) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text(
                    'Loading proximity alerts...',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                ],
              ),
            );
          }

          if (state is AlertError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Color(0xFFCC2222),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AlertsBloc>().add(const AlertsRequested());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<ProximityAlert> alerts = (state as AlertLoaded).alerts;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              children: [
                _buildStatsRow(alerts),
                const SizedBox(height: 20),
                ...alerts.map((ProximityAlert alert) {
                  final _AlertVisual visual = _resolveVisual(alert);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildAlertCard(
                      tag: alert.type,
                      title: alert.title,
                      description: alert.body,
                      tagIcon: visual.icon,
                      tagIconBg: visual.iconBackground,
                      tagIconColor: visual.iconColor,
                      leftBorderColor: visual.borderColor,
                      metricLabel: _metricLabel(alert.type),
                      metricValue: _metricValue(alert),
                      metricValueColor: visual.metricColor,
                      threshold: _thresholdText(alert),
                      uuid: alert.uuid,
                      buttonLabel: _buttonLabel(alert.action),
                      buttonColor: visual.buttonColor,
                      buttonTextColor: visual.buttonTextColor,
                    ),
                  );
                }),
                const SizedBox(height: 6),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(List<ProximityAlert> alerts) {
    final int activeScans = alerts.length;
    final int nearbyBeacons = alerts
        .where(
          (ProximityAlert alert) =>
              alert.currentDistance > 0 && alert.currentDistance <= 10,
        )
        .length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
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
                children: [
                  const Text(
                    'ACTIVE SCANS',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF888888),
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$activeScans',
                    style: const TextStyle(
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
                children: [
                  const Text(
                    'NEARBY BEACONS',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF888888),
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$nearbyBeacons',
                    style: const TextStyle(
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
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF555555),
                height: 1.55,
              ),
            ),
            const SizedBox(height: 14),
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

  String _metricLabel(String type) {
    switch (type) {
      case 'SIGNAL_LOST':
        return 'LAST SEEN';
      case 'HARDWARE_ERROR':
        return 'STATUS';
      case 'PERMISSION_DENIED':
        return 'PERMISSION';
      default:
        return 'CURRENT DISTANCE';
    }
  }

  String _metricValue(ProximityAlert alert) {
    switch (alert.type) {
      case 'SIGNAL_LOST':
        return '--';
      case 'HARDWARE_ERROR':
        return 'OFF';
      case 'PERMISSION_DENIED':
        return 'DENIED';
      default:
        return '${alert.currentDistance.toStringAsFixed(1)}m';
    }
  }

  String _thresholdText(ProximityAlert alert) {
    if (alert.thresholdMeters <= 0) {
      return 'Action: ${alert.action}';
    }
    return 'Threshold: ${alert.thresholdMeters.toStringAsFixed(1)}m';
  }

  String _buttonLabel(String action) {
    switch (action) {
      case 'navigate_to_details':
        return 'Open App';
      case 'show_welcome_message':
        return 'View Details';
      case 'auto_checkin':
        return 'Auto Check-in';
      case 'mark_as_inactive':
        return 'Retry Connection';
      case 'open_settings':
        return 'Open Settings';
      case 'request_permission':
        return 'Grant Access';
      default:
        return 'Open';
    }
  }

  _AlertVisual _resolveVisual(ProximityAlert alert) {
    switch (alert.style) {
      case 'amber_warning':
        return const _AlertVisual(
          icon: Icons.warning_amber_rounded,
          iconBackground: Color(0xFFFFF8E1),
          iconColor: Color(0xFFFFAA00),
          borderColor: Color(0xFFFFAA00),
          metricColor: Color(0xFFFFAA00),
          buttonColor: Color(0xFFFFAA00),
          buttonTextColor: Colors.white,
        );
      case 'success_green':
        return const _AlertVisual(
          icon: Icons.check_circle,
          iconBackground: Color(0xFFE8F8F0),
          iconColor: Color(0xFF2AAA6A),
          borderColor: Color(0xFF2AAA6A),
          metricColor: Color(0xFF2AAA6A),
          buttonColor: Color(0xFF2AAA6A),
          buttonTextColor: Colors.white,
        );
      case 'error_red':
        return const _AlertVisual(
          icon: Icons.error_outline,
          iconBackground: Color(0xFFFFEEEE),
          iconColor: Color(0xFFCC2222),
          borderColor: Color(0xFFCC2222),
          metricColor: Color(0xFFCC2222),
          buttonColor: Color(0xFFF0EFEB),
          buttonTextColor: Color(0xFF444444),
        );
      case 'info_blue':
      default:
        return const _AlertVisual(
          icon: Icons.my_location,
          iconBackground: Color(0xFFEEF0F8),
          iconColor: Color(0xFF1E3A9F),
          borderColor: Color(0xFF1E3A9F),
          metricColor: Color(0xFF1E3A9F),
          buttonColor: Color(0xFF1E3A9F),
          buttonTextColor: Colors.white,
        );
    }
  }
}

class _AlertVisual {
  const _AlertVisual({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.borderColor,
    required this.metricColor,
    required this.buttonColor,
    required this.buttonTextColor,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final Color borderColor;
  final Color metricColor;
  final Color buttonColor;
  final Color buttonTextColor;
}
