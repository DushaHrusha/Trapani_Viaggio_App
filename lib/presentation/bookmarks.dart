import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../bloc/cubits/bookmarks_cubit.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_app_bar.dart';
import '../core/constants/custom_background_with_gradient.dart';
import '../core/constants/grey_line.dart';
import '../core/constants/second_card.dart';
import '../data/models/bookmark.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Map<String, Animation> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _animations = {
      'appBar': _createAnimation(0.2, 0.4),
      'greyLine': _createAnimation(0.4, 0.5),
      'text': _createAnimation(0.5, 0.6),
      'cards': _createAnimation(0.5, 0.7),
      'bottomBar': Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.6, 0.8, curve: Curves.easeOutQuad),
            ),
          ),
    };

    _controller.forward();
  }

  Animation<double> _createAnimation(double begin, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: Curves.easeInOut),
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
      body: BlocBuilder<BookmarksCubit, List<Bookmark>>(
        builder: (context, bookmarks) => CustomBackgroundWithGradient(
          child: Column(
            children: [
              _buildAnimatedWidget(
                _animations['appBar']!,
                CustomAppBar(label: "bookmarks"),
              ),
              _buildAnimatedWidget(_animations['greyLine']!, GreyLine()),
              if (bookmarks.isEmpty)
                _buildEmptyState()
              else
                _buildBookmarksList(bookmarks),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildAnimatedWidget(Animation animation, Widget child) {
    return animation is Animation<Offset>
        ? SlideTransition(position: animation, child: child)
        : FadeTransition(opacity: animation as Animation<double>, child: child);
  }

  Widget _buildEmptyState() {
    return _buildAnimatedWidget(
      _animations['text']!,
      Container(
        margin: const EdgeInsets.only(top: 40),
        alignment: Alignment.center,
        child: const Text(
          'You have no bookmarks yet',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: BaseColors.text,
            fontSize: 21,
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarksList(List<Bookmark> bookmarks) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        itemCount: bookmarks.length,
        itemBuilder: (context, index) => _buildAnimatedWidget(
          _animations['cards']!,
          SecondCard(
            data: bookmarks[index].cardData,
            index: index,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: BaseColors.accent,
              fontSize: 21,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return _buildAnimatedWidget(
      _animations['bottomBar']!,
      BottomBar(currentScreen: widget),
    );
  }

  Widget _buildFAB() {
    return _buildAnimatedWidget(
      _animations['bottomBar']!,
      Container(
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
              onPressed: () {},
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
