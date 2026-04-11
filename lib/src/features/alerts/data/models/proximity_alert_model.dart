import '../../domain/entities/proximity_alert.dart';

class ProximityAlertModel extends ProximityAlert {
  const ProximityAlertModel({
    required super.type,
    required super.title,
    required super.body,
    required super.thresholdMeters,
    required super.currentDistance,
    required super.style,
    required super.uuid,
    required super.action,
  });

  factory ProximityAlertModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> payload =
        (json['payload'] as Map<String, dynamic>? ?? <String, dynamic>{});

    return ProximityAlertModel(
      type: json['type'] as String? ?? 'UNKNOWN',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      thresholdMeters: (json['threshold_meters'] as num? ?? 0).toDouble(),
      currentDistance: (json['current_distance'] as num? ?? 0).toDouble(),
      style: json['style'] as String? ?? 'info_blue',
      uuid: payload['uuid'] as String? ?? '',
      action: payload['action'] as String? ?? '',
    );
  }
}
