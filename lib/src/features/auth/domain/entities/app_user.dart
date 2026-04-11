import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({required this.id, this.displayName, this.email});

  final String id;
  final String? displayName;
  final String? email;

  @override
  List<Object?> get props => <Object?>[id, displayName, email];
}
