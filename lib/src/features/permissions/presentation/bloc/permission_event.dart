import 'package:equatable/equatable.dart';

sealed class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class PermissionStatusRequested extends PermissionEvent {
  const PermissionStatusRequested({this.silent = false});

  final bool silent;

  @override
  List<Object?> get props => <Object?>[silent];
}

class PermissionRequestSubmitted extends PermissionEvent {
  const PermissionRequestSubmitted();
}
