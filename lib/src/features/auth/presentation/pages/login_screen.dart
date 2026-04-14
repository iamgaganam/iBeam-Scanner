import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/presentation/widgets/app_animated_entrance.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          previous.status != current.status,
      listener: (BuildContext context, AuthState state) {
        if (state.status == AuthStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Builder(
        builder: (BuildContext context) {
          final AuthState authState = context.watch<AuthBloc>().state;
          final bool isLoading = authState.isLoading;

          return Stack(
            children: [
              AbsorbPointer(
                absorbing: isLoading,
                child: Scaffold(
                  backgroundColor: const Color(0xFFF2F1EF),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: AppAnimatedEntrance(
                          delay: const Duration(milliseconds: 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 72),
                              _buildAppIcon(),

                              const SizedBox(height: 40),
                              const Text(
                                'Welcome to Proximity\nAware',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111111),
                                  height: 1.25,
                                ),
                              ),

                              const SizedBox(height: 14),
                              const Text(
                                'Stay connected with precision location\ntracking and real-time proximity alerts.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF888888),
                                  height: 1.55,
                                ),
                              ),

                              const SizedBox(height: 48),
                              _buildAppleButton(isLoading),

                              const SizedBox(height: 14),
                              _buildGoogleButton(isLoading),

                              const SizedBox(height: 32),
                              _buildDivider(),

                              const SizedBox(height: 24),
                              _buildEmailField(),

                              const SizedBox(height: 20),
                              _buildFirebaseBadge(),

                              const SizedBox(height: 48),
                              _buildTermsText(),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Color(0xAAFFFFFF),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppIcon() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A9F),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.location_on, color: Colors.white, size: 36),
          Positioned(
            bottom: 18,
            right: 16,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_tethering,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppleButton(bool isLoading) {
    return CustomButton(
      label: 'Sign in with Apple',
      icon: Icons.apple,
      backgroundColor: const Color(0xFF111111),
      foregroundColor: Colors.white,
      onPressed: () {
        if (isLoading) {
          return;
        }
        context.read<AuthBloc>().add(const AuthAppleSignInRequested());
      },
    );
  }

  Widget _buildGoogleButton(bool isLoading) {
    return CustomButton(
      label: 'Sign in with Google',
      customIcon: _buildGoogleLogo(),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF111111),
      outlined: true,
      onPressed: () {
        if (isLoading) {
          return;
        }
        context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
      },
    );
  }

  Widget _buildGoogleLogo() {
    return SvgPicture.string(
      _googleLogoSvg,
      width: 20,
      height: 20,
      semanticsLabel: 'Google logo',
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFD6D5D0))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'OR ACCESS VIA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFFAAAAAA),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFFD6D5D0))),
      ],
    );
  }

  Widget _buildEmailField() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFEDECE8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 16, color: Color(0xFF111111)),
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirebaseBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E5E0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A9F),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, color: Colors.white, size: 11),
          ),
          const SizedBox(width: 8),
          const Text(
            'SECURE FIREBASE SSO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF555555),
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'By signing in, you agree to our\n',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF888888),
              height: 1.6,
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E3A9F),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF1E3A9F),
                ),
              ),
            ),
          ),
          const TextSpan(
            text: ' and ',
            style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E3A9F),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF1E3A9F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _googleLogoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 18 18">
  <path fill="#EA4335" d="M9 3.48c1.69 0 2.84.73 3.49 1.34l2.54-2.54C13.51.86 11.42 0 9 0 5.48 0 2.44 2.02.96 4.96l2.96 2.3C4.65 5.09 6.64 3.48 9 3.48z"/>
  <path fill="#4285F4" d="M17.64 9.2c0-.64-.06-1.25-.16-1.84H9v3.48h4.84c-.21 1.12-.84 2.07-1.79 2.71l2.84 2.2c1.66-1.53 2.75-3.78 2.75-6.55z"/>
  <path fill="#FBBC05" d="M3.92 10.74A5.41 5.41 0 013.64 9c0-.6.1-1.18.28-1.74L.96 4.96A8.99 8.99 0 000 9c0 1.45.35 2.82.96 4.04l2.96-2.3z"/>
  <path fill="#34A853" d="M9 18c2.42 0 4.45-.8 5.94-2.16l-2.84-2.2c-.79.53-1.8.84-3.1.84-2.36 0-4.35-1.59-5.08-3.74l-2.96 2.3C2.44 15.98 5.48 18 9 18z"/>
</svg>
''';
