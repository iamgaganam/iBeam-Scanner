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
      emit(
        state.copyWith(
          status: snapshot.isReady
              ? PermissionFlowStatus.ready
              : PermissionFlowStatus.actionRequired,
          snapshot: snapshot,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PermissionFlowStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onPermissionRequestSubmitted(
    PermissionRequestSubmitted event,
    Emitter<PermissionState> emit,
  ) async {
    emit(
      state.copyWith(status: PermissionFlowStatus.loading, clearError: true),
    );

    try {
      final PermissionSnapshot snapshot = await _requestPermissions();
      emit(
        state.copyWith(
          status: snapshot.isReady
              ? PermissionFlowStatus.ready
              : PermissionFlowStatus.actionRequired,
          snapshot: snapshot,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PermissionFlowStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
