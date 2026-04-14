import 'package:equatable/equatable.dart';

sealed class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class PermissionStatusRequested extends PermissionEvent {
  const PermissionStatusRequested({
    this.silent = false,
    this.requireConfirmation = true,
  });

  final bool silent;
  final bool requireConfirmation;

  @override
  List<Object?> get props => <Object?>[silent, requireConfirmation];
}

class PermissionRequestSubmitted extends PermissionEvent {
  const PermissionRequestSubmitted();
}
