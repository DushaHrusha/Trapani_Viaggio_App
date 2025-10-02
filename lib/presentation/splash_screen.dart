import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../core/adaptive_size_extension.dart';
import '../core/constants/base_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _backgroundAnimation;
  late final Animation<double> _subTextAnimation;
  late final Animation<double> _textAnimation;
  late final Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          duration: const Duration(milliseconds: 3000),
          vsync: this,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            context.go('/home');
          }
        });

    _backgroundAnimation = _createAnimation(0.2, 0.5, Curves.linear);
    _textAnimation = _createAnimation(0.55, 0.8, Curves.easeIn);
    _logoAnimation = _createAnimation(0.45, 0.7);
    _subTextAnimation = _createAnimation(0.7, 0.9, Curves.easeIn);

    _controller.forward();
  }

  Animation<double> _createAnimation(
    double start,
    double end, [
    Curve curve = Curves.linear,
  ]) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: curve),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBaselineText(
    String text,
    Animation<double> animation, {
    required double baseline,
    EdgeInsets? padding,
  }) {
    return FadeTransition(
      opacity: animation,
      child: Padding(
        padding: context.adaptivePadding(padding ?? EdgeInsets.zero),
        child: Baseline(
          baseline: context.adaptiveSize(baseline),
          baselineType: TextBaseline.alphabetic,
          child: Text(
            text,
            style: context.adaptiveTextStyle(
              fontSize: 36,
              fontFamily: 'Berlin Sans FB',
              fontWeight: FontWeight.w400,
              color: BaseColors.accent,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: _LightPainter(
                radius:
                    MediaQuery.of(context).size.height *
                    _backgroundAnimation.value,
                color: BaseColors.secondary,
              ),
              size: Size.infinite,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    _buildBaselineText(
                      'trpani',
                      _textAnimation,
                      baseline: 36 * 1.35,
                      padding: const EdgeInsets.only(right: 9),
                    ),
                    FadeTransition(
                      opacity: _logoAnimation,
                      child: SvgPicture.asset(
                        'assets/icons/Logo.svg',
                        height: context.adaptiveSize(50),
                      ),
                    ),
                    _buildBaselineText(
                      'viaggio',
                      _textAnimation,
                      baseline: 36 * 0.8,
                      padding: const EdgeInsets.only(left: 6),
                    ),
                  ],
                ),
                FadeTransition(
                  opacity: _subTextAnimation,
                  child: Text(
                    'tourists assistance',
                    style: context.adaptiveTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LightPainter extends CustomPainter {
  final double radius;
  final Color color;

  const _LightPainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      size.center(Offset.zero),
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_LightPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.color != color;
}
