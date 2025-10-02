import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../bloc/cubits/excursion_cubit.dart';
import '../bloc/state/excursion_state.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_app_bar.dart';
import '../core/constants/custom_background_with_gradient.dart';
import '../core/constants/first_card.dart';
import '../core/constants/grey_line.dart';
import '../core/constants/second_card.dart';

class ExcursionsList extends StatefulWidget {
  const ExcursionsList({super.key});

  @override
  createState() => _ExcursionsListState();
}

class _ExcursionsListState extends State<ExcursionsList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  // Константы для читаемости
  static const _animDuration = Duration(milliseconds: 3000);
  static const _appBarInterval = Interval(0.2, 0.5, curve: Curves.easeInOut);
  static const _cardsInterval = Interval(0.5, 0.8, curve: Curves.easeInOut);
  static const _slideInterval = Interval(0.5, 0.7, curve: Curves.easeOutQuad);
  static const _listPadding = EdgeInsets.symmetric(
    horizontal: 30,
    vertical: 32,
  );
  static const _cardTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    color: BaseColors.accent,
    fontSize: 21,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _animDuration, vsync: this);

    // Используем одну анимацию для fade-эффектов
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: _appBarInterval,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: _slideInterval));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppBar(label: "excursions list"),
          GreyLine(),
        ],
      ),
    );
  }

  Widget _buildExcursionCard(excursion, index) {
    final isFirst = index == 0;
    final card = isFirst
        ? FirstCard(data: excursion, index: index, style: _cardTextStyle)
        : SecondCard(data: excursion, style: _cardTextStyle, index: index);

    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: _cardsInterval),
      child: GestureDetector(
        onTap: () => context.go(
          '/home/main-menu/excursions-list/excursion-detail',
          extra: excursion,
        ),
        child: card,
      ),
    );
  }

  Widget _buildFloatingButton() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white),
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () => setState(() {}),
              child: SvgPicture.asset(
                "assets/icons/sliders.svg",
                color: BaseColors.accent,
                height: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.background,
      body: BlocBuilder<ExcursionCubit, ExcursionState>(
        builder: (context, state) => switch (state) {
          ExcursionInitial() => const Center(
            child: CircularProgressIndicator(),
          ),
          ExcursionLoaded() => CustomBackgroundWithGradient(
            child: Column(
              children: [
                _buildAnimatedHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: _listPadding,
                    itemCount: state.excursions.length,
                    itemBuilder: (context, index) =>
                        _buildExcursionCard(state.excursions[index], index),
                  ),
                ),
              ],
            ),
          ),
          _ => const Center(child: Text('Error loading excursions')),
        },
      ),
      bottomNavigationBar: SlideTransition(
        position: _slideAnimation,
        child: BottomBar(currentScreen: widget),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingButton(),
    );
  }
}
