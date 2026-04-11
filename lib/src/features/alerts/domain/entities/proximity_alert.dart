import 'package:equatable/equatable.dart';

class ProximityAlert extends Equatable {
  const ProximityAlert({
    required this.type,
    required this.title,
    required this.body,
    required this.thresholdMeters,
    required this.currentDistance,
    required this.style,
    required this.uuid,
    required this.action,
  });

  final String type;
  final String title;
  final String body;
  final double thresholdMeters;
  final double currentDistance;
  final String style;
  final String uuid;
  final String action;

  @override
  List<Object?> get props => <Object?>[
    type,
    title,
    body,
    thresholdMeters,
    currentDistance,
    style,
    uuid,
    action,
  ];
}
