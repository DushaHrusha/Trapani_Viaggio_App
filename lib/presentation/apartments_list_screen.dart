import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../bloc/cubits/apartments_cubit.dart';
import '../bloc/state/apartments_state.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_app_bar.dart';
import '../core/constants/custom_background_with_gradient.dart';
import '../core/constants/grey_line.dart';
import '../core/constants/second_card.dart';

class ApartmentsListScreen extends StatefulWidget {
  const ApartmentsListScreen({super.key});

  @override
  createState() => _ApartmentsListScreenState();
}

class _ApartmentsListScreenState extends State<ApartmentsListScreen>
    with SingleTickerProviderStateMixin {
  final Map<int, int> ratings = {};
  late AnimationController _controller;
  late Animation<double> _appBarFade;
  late Animation<Offset> _bottomSlide;
  late Animation<double> _cardsFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _appBarFade = _createFadeAnimation(0.2, 0.5);
    _cardsFade = _createFadeAnimation(0.5, 0.8);
    _bottomSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 0.7, curve: Curves.easeOutQuad),
          ),
        );

    _controller.forward();
  }

  Animation<double> _createFadeAnimation(double begin, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: Curves.easeInOut),
      ),
    );
  }

  Widget _buildAnimatedWidget(Animation animation, Widget child) {
    if (animation is Animation<double>) {
      return FadeTransition(opacity: animation, child: child);
    }
    return SlideTransition(
      position: animation as Animation<Offset>,
      child: child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.background,
      body: BlocBuilder<ApartmentCubit, ApartmentsState>(
        builder: (context, state) {
          if (state is ApartmentsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ApartmentsLoaded) {
            return CustomBackgroundWithGradient(
              child: Column(
                children: [
                  _buildAnimatedWidget(
                    _appBarFade,
                    const CustomAppBar(label: "apartments"),
                  ),
                  _buildAnimatedWidget(_appBarFade, const GreyLine()),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 32,
                      ),
                      itemCount: state.apartments.length,
                      itemBuilder: (context, index) =>
                          _buildApartmentCard(state.apartments[index], index),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Error loading apartments'));
        },
      ),
      bottomNavigationBar: _buildAnimatedWidget(
        _bottomSlide,
        BottomBar(currentScreen: widget),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingButton(),
    );
  }

  Widget _buildApartmentCard(apartment, int index) {
    return _buildAnimatedWidget(
      _cardsFade,
      GestureDetector(
        onTap: () => context.go(
          '/home/main-menu/apartments-list/apartment-detail',
          extra: apartment,
        ),
        child: SecondCard(
          index: index,
          data: apartment,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: BaseColors.accent,
            fontSize: 21,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return _buildAnimatedWidget(
      _bottomSlide,
      Container(
        margin: const EdgeInsets.only(bottom: 30),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
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
}
