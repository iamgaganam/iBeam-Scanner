import 'package:equatable/equatable.dart';

import '../../domain/entities/permission_snapshot.dart';

enum PermissionFlowStatus { initial, loading, ready, actionRequired, error }

class PermissionState extends Equatable {
  const PermissionState({
    required this.status,
    this.snapshot,
    this.errorMessage,
    this.userConfirmedGrant = false,
  });

  const PermissionState.initial() : this(status: PermissionFlowStatus.initial);

  final PermissionFlowStatus status;
  final PermissionSnapshot? snapshot;
  final String? errorMessage;
  final bool userConfirmedGrant;

  bool get isReady => status == PermissionFlowStatus.ready;
  bool get canProceed => isReady && userConfirmedGrant;

  PermissionState copyWith({
    PermissionFlowStatus? status,
    PermissionSnapshot? snapshot,
    String? errorMessage,
    bool? userConfirmedGrant,
    bool clearError = false,
  }) {
    return PermissionState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      userConfirmedGrant: userConfirmedGrant ?? this.userConfirmedGrant,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    snapshot,
    errorMessage,
    userConfirmedGrant,
  ];
}
