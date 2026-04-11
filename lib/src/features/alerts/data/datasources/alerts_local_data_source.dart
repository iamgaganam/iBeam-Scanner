import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/proximity_alert_model.dart';

class AlertsLocalDataSource {
  Future<List<ProximityAlertModel>> getAlerts() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    final String jsonString = await rootBundle.loadString(
      'assets/data/alerts.json',
    );
    final Map<String, dynamic> decoded =
        jsonDecode(jsonString) as Map<String, dynamic>;

    final List<dynamic> alerts =
        decoded['alerts'] as List<dynamic>? ?? <dynamic>[];

    return alerts
        .map(
          (dynamic item) =>
              ProximityAlertModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
