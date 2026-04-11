import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/app_shell/presentation/pages/main_layout.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/beacon_scanner/presentation/bloc/beacon_scanner_bloc.dart';
import '../../features/beacon_scanner/presentation/bloc/beacon_scanner_event.dart';
import '../../features/permissions/presentation/bloc/permission_bloc.dart';
import '../../features/permissions/presentation/bloc/permission_event.dart';
import '../../features/permissions/presentation/bloc/permission_state.dart';
import '../../features/permissions/presentation/pages/setup_permission_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (AuthState previous, AuthState current) =>
              previous.status != current.status,
          listener: (BuildContext context, AuthState state) {
            if (state.isAuthenticated) {
              context.read<BeaconScannerBloc>().add(
                const BeaconScannerInitializeRequested(),
              );
              context.read<PermissionBloc>().add(
                const PermissionStatusRequested(),
              );
            } else if (state.status == AuthStatus.unauthenticated) {
              context.read<BeaconScannerBloc>().add(
                const BeaconScannerStopRequested(),
              );
            }
          },
        ),
        BlocListener<PermissionBloc, PermissionState>(
          listenWhen: (PermissionState previous, PermissionState current) =>
              previous.status != current.status,
          listener: (BuildContext context, PermissionState state) {
            final AuthState authState = context.read<AuthBloc>().state;
            if (!authState.isAuthenticated) {
              return;
            }

            if (state.isReady) {
              context.read<BeaconScannerBloc>().add(
                const BeaconScannerStartRequested(),
              );
            } else {
              context.read<BeaconScannerBloc>().add(
                const BeaconScannerStopRequested(),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState authState) {
          if (authState.status == AuthStatus.initial || authState.isLoading) {
            return const _GateLoading();
          }

          if (!authState.isAuthenticated) {
            return const LoginScreen();
          }

          return BlocBuilder<PermissionBloc, PermissionState>(
            builder: (BuildContext context, PermissionState permissionState) {
              if (permissionState.status == PermissionFlowStatus.initial ||
                  permissionState.status == PermissionFlowStatus.loading) {
                return const SetupPermissionScreen();
              }

              if (permissionState.isReady) {
                return const MainLayout();
              }

              return const SetupPermissionScreen();
            },
          );
        },
      ),
    );
  }
}

class _GateLoading extends StatelessWidget {
  const _GateLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF2F1EF),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
