import 'dart:async';

import 'package:flutter/material.dart';

class WelcomeSplashScreen extends StatefulWidget {
  const WelcomeSplashScreen({
    super.key,
    required this.nextScreen,
    this.duration = const Duration(milliseconds: 2300),
  });

  final Widget nextScreen;
  final Duration duration;

  @override
  State<WelcomeSplashScreen> createState() => _WelcomeSplashScreenState();
}

class _WelcomeSplashScreenState extends State<WelcomeSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;
  Timer? _forwardTimer;
  bool _showNext = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1350),
    );

    _logoScale = Tween<double>(
      begin: 0.72,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.55)),
    );

    _ringScale = Tween<double>(
      begin: 0.86,
      end: 1.14,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _ringOpacity = Tween<double>(
      begin: 0.22,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.repeat(period: const Duration(milliseconds: 1500));

    _forwardTimer = Timer(widget.duration, () {
      if (!mounted) {
        return;
      }
      _controller.stop();
      setState(() {
        _showNext = true;
      });
    });
  }

  @override
  void dispose() {
    _forwardTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 520),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1).animate(animation),
            child: child,
          ),
        );
      },
      child: _showNext
          ? KeyedSubtree(
              key: const ValueKey<String>('next_screen'),
              child: widget.nextScreen,
            )
          : _SplashScene(
              key: const ValueKey<String>('splash_screen'),
              logoScale: _logoScale,
              logoOpacity: _logoOpacity,
              ringScale: _ringScale,
              ringOpacity: _ringOpacity,
            ),
    );
  }
}

class _SplashScene extends StatelessWidget {
  const _SplashScene({
    super.key,
    required this.logoScale,
    required this.logoOpacity,
    required this.ringScale,
    required this.ringOpacity,
  });

  final Animation<double> logoScale;
  final Animation<double> logoOpacity;
  final Animation<double> ringScale;
  final Animation<double> ringOpacity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFF2F1EF), Color(0xFFE7ECF8)],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -50,
              right: -40,
              child: _BlurCircle(
                size: 180,
                color: const Color(0xFF1E3A9F).withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -20,
              child: _BlurCircle(
                size: 210,
                color: const Color(0xFF4A6BD6).withValues(alpha: 0.10),
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: Listenable.merge(<Listenable>[
                          ringScale,
                          ringOpacity,
                          logoScale,
                          logoOpacity,
                        ]),
                        builder: (BuildContext context, Widget? child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Transform.scale(
                                scale: ringScale.value,
                                child: Container(
                                  width: 148,
                                  height: 148,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFF1E3A9F,
                                    ).withValues(alpha: ringOpacity.value),
                                  ),
                                ),
                              ),
                              FadeTransition(
                                opacity: logoOpacity,
                                child: ScaleTransition(
                                  scale: logoScale,
                                  child: Container(
                                    width: 118,
                                    height: 118,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: const Color(
                                            0xFF1E3A9F,
                                          ).withValues(alpha: 0.16),
                                          blurRadius: 24,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Proximity Aware',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111111),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Preparing secure iBeacon scan environment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6F6F6F),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 26),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Color(0xFF1E3A9F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
