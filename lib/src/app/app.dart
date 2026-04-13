import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/alerts/presentation/bloc/alerts_bloc.dart';
import '../features/alerts/presentation/pages/refined_alerts_screen.dart';
import '../features/app_shell/presentation/pages/main_layout.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/beacon_scanner/presentation/bloc/beacon_scanner_bloc.dart';
import '../features/beacon_scanner/presentation/pages/dashboard_screen.dart';
import '../features/permissions/presentation/bloc/permission_bloc.dart';
import '../features/permissions/presentation/pages/setup_permission_screen.dart';
import '../features/settings/presentation/pages/settings_screen.dart';
import 'di/injector.dart';
import 'routes/app_routes.dart';
import 'widgets/auth_gate.dart';

class ProxiMateApp extends StatelessWidget {
  const ProxiMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthSubscriptionRequested()),
        ),
        BlocProvider<PermissionBloc>(create: (_) => sl<PermissionBloc>()),
        BlocProvider<BeaconScannerBloc>(create: (_) => sl<BeaconScannerBloc>()),
        BlocProvider<AlertsBloc>(create: (_) => sl<AlertsBloc>()),
      ],
      child: MaterialApp(
        title: 'ProxiMate',
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
            ),
            child: child!,
          );
        },
        theme: ThemeData(
          fontFamily: 'SF Pro Display',
          scaffoldBackgroundColor: const Color(0xFFF2F1EF),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A9F)),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: const AuthGate(),
        routes: {
          AppRoutes.main: (context) => const MainLayout(),
          AppRoutes.dashboard: (context) => const DashboardScreen(),
          AppRoutes.settings: (context) => const SettingsScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.setupPermission: (context) => const SetupPermissionScreen(),
          AppRoutes.refinedAlerts: (context) => const RefinedAlertsScreen(),
        },
      ),
    );
  }
}
