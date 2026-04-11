import 'package:equatable/equatable.dart';

import '../../domain/entities/proximity_alert.dart';

sealed class AlertsState extends Equatable {
  const AlertsState();

  @override
  List<Object?> get props => <Object?>[];
}

class AlertInitial extends AlertsState {
  const AlertInitial();
}

class AlertLoading extends AlertsState {
  const AlertLoading();
}

class AlertLoaded extends AlertsState {
  const AlertLoaded(this.alerts);

  final List<ProximityAlert> alerts;

  @override
  List<Object?> get props => <Object?>[alerts];
}

class AlertError extends AlertsState {
  const AlertError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
