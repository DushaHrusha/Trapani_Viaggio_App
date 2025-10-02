import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../core/adaptive_size_extension.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_app_bar.dart';
import '../core/constants/custom_background_with_gradient.dart';
import '../core/constants/grey_line.dart';
import '../core/routing/app_routes.dart';
import '../data/models/menu_item.dart';

class _AnimationConfig {
  final double start;
  final double end;
  final Curve curve;

  const _AnimationConfig(this.start, this.end, [this.curve = Curves.easeOut]);
}

class MenuAnimations {
  final AnimationController controller;

  static const _configs = {
    'appBar': _AnimationConfig(0.0, 0.4),
    'search': _AnimationConfig(0.3, 0.5),
    'circle': _AnimationConfig(0.4, 0.7),
    'text': _AnimationConfig(0.3, 0.9, Curves.easeInOut),
    'center': _AnimationConfig(0.4, 0.75, Curves.easeInOut),
    'bottomBar': _AnimationConfig(0.5, 0.7),
  };

  MenuAnimations(this.controller);

  Animation<double> _createAnimation(String key) {
    final config = _configs[key]!;
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(config.start, config.end, curve: config.curve),
      ),
    );
  }

  late final appBar = _createAnimation('appBar');
  late final search = _createAnimation('search');
  late final circle = _createAnimation('circle');
  late final text = _createAnimation('text');
  late final center = _createAnimation('center');
  late final bottomBar = _createAnimation('bottomBar');
}

class CircularMenuScreen extends StatefulWidget {
  const CircularMenuScreen({super.key});

  @override
  createState() => _CircularMenuScreenState();
}

class _CircularMenuScreenState extends State<CircularMenuScreen>
    with SingleTickerProviderStateMixin {
  static const _menuItems = [
    MenuItem(
      label: 'Apartment',
      iconPath: 'assets/icons/keys.svg',
      route: AppRouter.apartments,
    ),
    MenuItem(
      label: 'Auto',
      iconPath: 'assets/icons/auto.svg',
      route: AppRouter.vehicleDetailsCars,
    ),
    MenuItem(
      label: 'Moto',
      iconPath: 'assets/icons/Moto.svg',
      route: AppRouter.vehicleDetailsMotorcycles,
    ),
    MenuItem(
      label: 'Bicycle',
      iconPath: 'assets/icons/Bicycle.svg',
      route: AppRouter.vehicleDetailsVespa,
    ),
    MenuItem(
      label: 'Vespa',
      iconPath: 'assets/icons/Vespa.svg',
      route: AppRouter.vehicleDetailsVespa,
    ),
    MenuItem(
      label: 'Excursion',
      iconPath: 'assets/icons/Excursion.svg',
      route: AppRouter.excursions,
    ),
  ];

  late final AnimationController _controller;
  late final MenuAnimations _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _animations = MenuAnimations(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackgroundWithGradient(
        child: Column(
          children: [
            _buildAnimatedWidget(
              _animations.appBar,
              CustomAppBar(label: "trapani viaggio"),
            ),
            _buildAnimatedWidget(_animations.search, GreyLine()),
            _buildSearchBar(),
            _buildCircularMenu(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAnimatedWidget(Animation<double> animation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  Widget _buildSearchBar() {
    return FadeTransition(
      opacity: _animations.search,
      child: Padding(
        padding: context.adaptivePadding(
          const EdgeInsets.only(top: 48, left: 30, right: 30),
        ),
        child: Container(
          height: context.adaptiveSize(40),
          decoration: BoxDecoration(
            color: BaseColors.background,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color.fromRGBO(224, 224, 224, 1)),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: context.adaptivePadding(
                  const EdgeInsets.only(left: 28, right: 6),
                ),
                child: SizedBox(
                  width: context.adaptiveSize(20),
                  height: context.adaptiveSize(20),
                  child: SvgPicture.asset(
                    "assets/icons/search.svg",
                    color: BaseColors.primary,
                  ),
                ),
              ),
              hintText: 'What do you want to find in Trapani?',
              hintStyle: TextStyle(
                fontSize: context.adaptiveSize(14),
                height: 1.0,
                color: BaseColors.primary,
                fontStyle: FontStyle.italic,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14, height: 1.0),
            maxLines: 1,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ),
    );
  }

  Widget _buildCircularMenu() {
    final size = MediaQuery.of(context).size.shortestSide * 0.25;
    final center = Offset(size * 2, size * 2);
    final radius = size * 1.1;

    return SizedBox(
      width: size * 4,
      height: size * 5,
      child: Padding(
        padding: context.adaptivePadding(const EdgeInsets.only(top: 45.0)),
        child: Stack(
          children: List.generate(7, (index) {
            final isCenter = index == 6;
            final angle = isCenter ? 0.0 : (index * 60 - 90) * (pi / 180);
            final offset = isCenter
                ? Offset(size * 2 - 4, size * 2 - 4)
                : Offset(
                    center.dx + radius * cos(angle),
                    center.dy + radius * sin(angle),
                  );

            return Positioned(
              left: offset.dx - size / 2,
              top: offset.dy - size / 2,
              child: isCenter
                  ? _buildCenterCircle(size + 8)
                  : _buildMenuItem(size, index),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMenuItem(double size, int index) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animations.circle,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: () => context.go(_menuItems[index].route),
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: BaseColors.backgroundCircles,
              shape: BoxShape.circle,
            ),
            child: _buildMenuItemContent(size, index),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemContent(double size, int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animations.text,
          curve: Interval(0.05 * index, 0.2 * index, curve: Curves.easeInOut),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            _menuItems[index].iconPath,
            color: BaseColors.secondary,
          ),
          SizedBox(height: size * 0.03),
          Text(
            _menuItems[index].label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size * 0.13,
              color: BaseColors.secondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterCircle(double size) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animations.center,
          curve: const Interval(0.7, 1.0, curve: Curves.linear),
        ),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: CustomPaint(
          painter: DashedCirclePainter(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "What are you looking for?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size * 0.14,
                  color: BaseColors.accent,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _animations.bottomBar,
              curve: Curves.easeOut,
            ),
          ),
      child: BottomBar(currentScreen: widget),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BaseColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    const dashWidth = 5.0;
    const dashSpace = 5.0;
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    double startAngle = 0;
    while (startAngle < 2 * pi) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashWidth / radius,
        false,
        paint,
      );
      startAngle += (dashWidth + dashSpace) / radius;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
