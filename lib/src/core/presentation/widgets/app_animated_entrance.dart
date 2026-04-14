import 'dart:async';

import 'package:flutter/material.dart';

class AppAnimatedEntrance extends StatefulWidget {
  const AppAnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 460),
    this.curve = Curves.easeOutCubic,
    this.beginOffset = const Offset(0, 0.04),
    this.endOffset = Offset.zero,
    this.beginOpacity = 0,
    this.endOpacity = 1,
    this.beginScale = 0.98,
    this.endScale = 1,
    this.enabled = true,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset beginOffset;
  final Offset endOffset;
  final double beginOpacity;
  final double endOpacity;
  final double beginScale;
  final double endScale;
  final bool enabled;

  @override
  State<AppAnimatedEntrance> createState() => _AppAnimatedEntranceState();
}

class _AppAnimatedEntranceState extends State<AppAnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;
  late Animation<double> _scale;
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    _buildAnimations();
    _start();
  }

  @override
  void didUpdateWidget(covariant AppAnimatedEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.dispose();
      _buildAnimations();
      _start();
      return;
    }

    if (oldWidget.delay != widget.delay ||
        oldWidget.enabled != widget.enabled) {
      _start();
      return;
    }

    final bool tweensChanged =
        oldWidget.beginOffset != widget.beginOffset ||
        oldWidget.endOffset != widget.endOffset ||
        oldWidget.beginOpacity != widget.beginOpacity ||
        oldWidget.endOpacity != widget.endOpacity ||
        oldWidget.beginScale != widget.beginScale ||
        oldWidget.endScale != widget.endScale ||
        oldWidget.curve != widget.curve;

    if (tweensChanged) {
      _buildAnimatedValues();
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _buildAnimations() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _buildAnimatedValues();
  }

  void _buildAnimatedValues() {
    final Animation<double> curved = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _opacity = Tween<double>(
      begin: widget.beginOpacity,
      end: widget.endOpacity,
    ).animate(curved);

    _offset = Tween<Offset>(
      begin: widget.beginOffset,
      end: widget.endOffset,
    ).animate(curved);

    _scale = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    ).animate(curved);
  }

  void _start() {
    _startTimer?.cancel();

    if (!widget.enabled) {
      _controller.value = 1;
      return;
    }

    _controller.value = 0;

    if (widget.delay == Duration.zero) {
      _controller.forward();
      return;
    }

    _startTimer = Timer(widget.delay, () {
      if (!mounted) {
        return;
      }
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}
