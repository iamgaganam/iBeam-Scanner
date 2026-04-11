import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_alerts.dart';
import 'alerts_event.dart';
import 'alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  AlertsBloc({required GetAlerts getAlerts})
    : _getAlerts = getAlerts,
      super(const AlertInitial()) {
    on<AlertsRequested>(_onAlertsRequested);
  }

  final GetAlerts _getAlerts;

  Future<void> _onAlertsRequested(
    AlertsRequested event,
    Emitter<AlertsState> emit,
  ) async {
    emit(const AlertLoading());
    try {
      final alerts = await _getAlerts();
      emit(AlertLoaded(alerts));
    } catch (error) {
      emit(AlertError(error.toString()));
    }
  }
}
