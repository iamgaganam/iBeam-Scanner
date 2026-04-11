import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../alerts/presentation/pages/refined_alerts_screen.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../beacon_scanner/presentation/pages/dashboard_screen.dart';
import '../../../settings/presentation/pages/settings_screen.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_app_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;

  final List<Widget> _screens = const [
    DashboardScreen(),
    RefinedAlertsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (_currentIndex != index) {
      _fadeController.reset();
      setState(() {
        _currentIndex = index;
      });
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        currentIndex: _currentIndex,
        onTapTab: _onTabChanged,
        onLogout: () {
          context.read<AuthBloc>().add(const AuthSignOutRequested());
        },
      ),
      body: FadeTransition(
        opacity: _fadeController,
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
