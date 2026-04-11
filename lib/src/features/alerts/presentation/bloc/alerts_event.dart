import 'package:equatable/equatable.dart';

sealed class AlertsEvent extends Equatable {
  const AlertsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class AlertsRequested extends AlertsEvent {
  const AlertsRequested();
}
