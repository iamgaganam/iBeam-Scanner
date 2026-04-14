import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/permission_snapshot.dart';
import '../../domain/usecases/get_permission_status.dart';
import '../../domain/usecases/request_permissions.dart';
import 'permission_event.dart';
import 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc({
    required GetPermissionStatus getPermissionStatus,
    required RequestPermissions requestPermissions,
  }) : _getPermissionStatus = getPermissionStatus,
       _requestPermissions = requestPermissions,
       super(const PermissionState.initial()) {
    on<PermissionStatusRequested>(_onPermissionStatusRequested);
    on<PermissionRequestSubmitted>(_onPermissionRequestSubmitted);
  }

  final GetPermissionStatus _getPermissionStatus;
  final RequestPermissions _requestPermissions;
  bool _requestInFlight = false;

  Future<void> _onPermissionStatusRequested(
    PermissionStatusRequested event,
    Emitter<PermissionState> emit,
  ) async {
    if (!event.silent) {
      emit(
        state.copyWith(status: PermissionFlowStatus.loading, clearError: true),
      );
    }

    try {
      final PermissionSnapshot snapshot = await _getPermissionStatus();
      final bool allowImmediateProceed =
          snapshot.isReady && !event.requireConfirmation;
      final PermissionFlowStatus status = allowImmediateProceed
          ? PermissionFlowStatus.ready
          : PermissionFlowStatus.actionRequired;

      emit(
        state.copyWith(
          status: status,
          snapshot: snapshot,
          userConfirmedGrant: allowImmediateProceed,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PermissionFlowStatus.error,
          errorMessage: error.toString(),
          userConfirmedGrant: false,
        ),
      );
    }
  }

  Future<void> _onPermissionRequestSubmitted(
    PermissionRequestSubmitted event,
    Emitter<PermissionState> emit,
  ) async {
    if (_requestInFlight) {
      return;
    }

    _requestInFlight = true;
    emit(
      state.copyWith(status: PermissionFlowStatus.loading, clearError: true),
    );

    try {
      final PermissionSnapshot snapshot = await _requestPermissions();
      final bool isReady = snapshot.isReady;
      emit(
        state.copyWith(
          status: isReady
              ? PermissionFlowStatus.ready
              : PermissionFlowStatus.actionRequired,
          snapshot: snapshot,
          userConfirmedGrant: isReady,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PermissionFlowStatus.error,
          errorMessage: error.toString(),
          userConfirmedGrant: false,
        ),
      );
    } finally {
      _requestInFlight = false;
    }
  }
}
