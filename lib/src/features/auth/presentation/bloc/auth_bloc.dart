import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/usecases/observe_auth_state.dart';
import '../../domain/usecases/sign_in_with_apple.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required ObserveAuthState observeAuthState,
    required SignInWithGoogle signInWithGoogle,
    required SignInWithApple signInWithApple,
    required SignOut signOut,
  }) : _observeAuthState = observeAuthState,
       _signInWithGoogle = signInWithGoogle,
       _signInWithApple = signInWithApple,
       _signOut = signOut,
       super(const AuthState.initial()) {
    on<AuthSubscriptionRequested>(_onAuthSubscriptionRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthAppleSignInRequested>(_onAppleSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final ObserveAuthState _observeAuthState;
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithApple _signInWithApple;
  final SignOut _signOut;

  StreamSubscription<AppUser?>? _authSubscription;

  Future<void> _onAuthSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    await _authSubscription?.cancel();
    _authSubscription = _observeAuthState().listen((AppUser? user) {
      add(AuthUserChanged(user));
    });
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user == null) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: event.user,
        clearError: true,
      ),
    );
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      await _signInWithGoogle();
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onAppleSignInRequested(
    AuthAppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      await _signInWithApple();
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _signOut();
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}
