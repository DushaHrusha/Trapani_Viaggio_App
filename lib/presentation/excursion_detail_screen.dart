import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../core/adaptive_size_extension.dart';
import '../bloc/cubits/bookmarks_cubit.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_app_bar.dart';
import '../core/constants/custom_background_with_gradient.dart';
import '../core/constants/custom_text_field_with_gradient_button.dart';
import '../core/constants/grey_line.dart';
import '../data/models/bookmark.dart';
import '../data/models/excursion_model.dart';
import 'apartment_detail_screen.dart';

class ExcursionDetailScreen extends StatefulWidget {
  final Excursion excursion;

  const ExcursionDetailScreen({super.key, required this.excursion});

  @override
  createState() => _ExcursionDetailScreenState();
}

class _ExcursionDetailScreenState extends State<ExcursionDetailScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  final _scrollController = ScrollController();
  late final AnimationController _animationController;
  late final Excursion _excursion;

  int _currentImagePage = 0;
  int _currentIconPage = 0;

  // Константы для анимаций
  static const _animDuration = Duration(milliseconds: 3000);
  static const _scrollDuration = Duration(milliseconds: 300);
  static const _iconWidth = 80.0;
  static const _iconsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _excursion = widget.excursion;
    _setupAnimations();
    _setupPageListener();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: _animDuration,
      vsync: this,
    );
    _animationController.forward();
  }

  void _setupPageListener() {
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentImagePage) {
        setState(() => _currentImagePage = page);
      }
    });
  }

  Animation<T> _createAnimation<T>({
    required T begin,
    required T end,
    required double startInterval,
    required double endInterval,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<T>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(startInterval, endInterval, curve: curve),
      ),
    );
  }

  void _scrollIcons(bool forward) {
    final maxPage = _excursion.iconServices.length - _iconsPerPage;
    final newPage = forward
        ? (_currentIconPage < maxPage ? _currentIconPage + 1 : _currentIconPage)
        : (_currentIconPage > 0 ? _currentIconPage - 1 : _currentIconPage);

    if (newPage != _currentIconPage) {
      setState(() => _currentIconPage = newPage);
      _scrollController.animateTo(
        newPage * _iconWidth,
        duration: _scrollDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarAnim = _createAnimation<double>(
      begin: 0.0,
      end: 1.0,
      startInterval: 0.2,
      endInterval: 0.5,
    );
    final cardsAnim = _createAnimation<double>(
      begin: 0.0,
      end: 1.0,
      startInterval: 0.5,
      endInterval: 1.0,
    );
    final bottomBarAnim = _createAnimation<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
      startInterval: 0.5,
      endInterval: 0.7,
      curve: Curves.easeOutQuad,
    );

    return Scaffold(
      body: CustomBackgroundWithGradient(
        child: Column(
          children: [
            FadeTransition(
              opacity: appBarAnim,
              child: Column(
                children: [
                  const CustomAppBar(label: "excursion info"),
                  const GreyLine(),
                ],
              ),
            ),
            SizedBox(height: context.adaptiveSize(40)),
            Expanded(
              child: FadeTransition(
                opacity: cardsAnim,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  children: [
                    _buildImageCarousel(),
                    SizedBox(height: context.adaptiveSize(12)),
                    _buildTitle(),
                    SizedBox(height: context.adaptiveSize(16)),
                    _buildDescription(),
                    SizedBox(height: context.adaptiveSize(24)),
                    _buildTimeInfo(),
                    SizedBox(height: context.adaptiveSize(32)),
                    _buildIconServices(),
                    SizedBox(height: context.adaptiveSize(40)),
                    const GreyLine(),
                    SizedBox(height: context.adaptiveSize(40)),
                    _buildDetailsSection(),
                    SizedBox(height: context.adaptiveSize(40)),
                    const GreyLine(),
                    SizedBox(height: context.adaptiveSize(24)),
                    _buildRatingSection(),
                    SizedBox(height: context.adaptiveSize(27)),
                    const GreyLine(),
                    SizedBox(height: context.adaptiveSize(40)),
                    _buildBookingButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SlideTransition(
        position: bottomBarAnim,
        child: BottomBar(currentScreen: widget),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.adaptiveSize(32)),
          child: SizedBox(
            height: context.adaptiveSize(180),
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _excursion.imageUrl.length,
              itemBuilder: (context, index) =>
                  Image.asset(_excursion.imageUrl[index], fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned(
          right: context.adaptiveSize(24),
          top: context.adaptiveSize(24),
          child: _buildBookmarkButton(),
        ),
        Positioned(
          bottom: context.adaptiveSize(16),
          left: 0,
          right: 0,
          child: _buildPageIndicator(
            _excursion.imageUrl.length,
            _currentImagePage,
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkButton() {
    return BlocBuilder<BookmarksCubit, List<Bookmark>>(
      builder: (context, bookmarks) {
        final isBookmarked = context.read<BookmarksCubit>().isBookmarked(
          _excursion,
        );
        return GestureDetector(
          onTap: () =>
              context.read<BookmarksCubit>().toggleBookmark(_excursion),
          child: Container(
            height: context.adaptiveSize(56),
            width: context.adaptiveSize(56),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.adaptiveSize(16)),
              color: const Color.fromARGB(87, 255, 255, 255),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.adaptiveSize(16)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                  color: isBookmarked
                      ? BaseColors.accent
                      : const Color.fromARGB(255, 251, 251, 253),
                  size: context.adaptiveSize(25),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator(int count, int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index
                ? BaseColors.accent
                : BaseColors.background,
          ),
        );
      }),
    );
  }

  Widget _buildTitle() {
    return Text(
      _excursion.title,
      style: context.adaptiveTextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: BaseColors.text,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      _excursion.description,
      style: context.adaptiveTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color.fromARGB(255, 130, 130, 130),
      ),
    );
  }

  Widget _buildTimeInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildInfoColumn("Duration:", "${_excursion.duration} hours"),
        SizedBox(width: context.adaptiveSize(100)),
        _buildInfoColumn(
          "Starting time:",
          DateFormat('HH:mm').format(_excursion.startingTime),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.adaptiveTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: BaseColors.text,
          ),
        ),
        Text(
          value,
          style: context.adaptiveTextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: BaseColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildIconServices() {
    final canScrollLeft = _currentIconPage > 0;
    final canScrollRight =
        _currentIconPage < _excursion.iconServices.length - _iconsPerPage;

    return Row(
      children: [
        if (canScrollLeft)
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: context.adaptiveSize(20)),
            onPressed: () => _scrollIcons(false),
          ),
        Expanded(
          child: SizedBox(
            height: context.adaptiveSize(48),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _excursion.iconServices.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(right: context.adaptiveSize(12)),
                height: context.adaptiveSize(48),
                width: context.adaptiveSize(46),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 224, 224, 224),
                  ),
                ),
                child: Icon(
                  _excursion.iconServices[index],
                  color: BaseColors.text,
                  size: context.adaptiveSize(20),
                ),
              ),
            ),
          ),
        ),
        if (canScrollRight)
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: context.adaptiveSize(14),
              color: const Color.fromARGB(255, 189, 189, 189),
            ),
            onPressed: () => _scrollIcons(true),
          ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailBlock('Transfer:', _excursion.transfer),
        SizedBox(height: context.adaptiveSize(32)),
        _buildListBlock(
          'Sights:',
          _excursion.sights,
          Icons.check,
          BaseColors.accent,
        ),
        SizedBox(height: context.adaptiveSize(32)),
        _buildListBlock(
          'Not included:',
          _excursion.notIncluded,
          Icons.clear,
          BaseColors.text,
        ),
        SizedBox(height: context.adaptiveSize(32)),
        _buildDetailBlock('Take with you:', _excursion.takeWithYou),
      ],
    );
  }

  Widget _buildDetailBlock(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.adaptiveTextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: BaseColors.text,
          ),
        ),
        SizedBox(height: context.adaptiveSize(8)),
        Text(
          content,
          style: context.adaptiveTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ),
      ],
    );
  }

  Widget _buildListBlock(
    String title,
    List<String> items,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.adaptiveTextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: BaseColors.text,
          ),
        ),
        SizedBox(height: context.adaptiveSize(8)),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: context.adaptiveSize(8)),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: context.adaptiveSize(16)),
                SizedBox(width: context.adaptiveSize(8)),
                Text(
                  item,
                  style: context.adaptiveTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 130, 130, 130),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              _excursion.rating.toString(),
              style: context.adaptiveTextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: BaseColors.accent,
              ),
            ),
            SizedBox(width: context.adaptiveSize(6)),
            StarRating(rating: _excursion.rating),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${_excursion.numberReviews} guest reviews",
              style: context.adaptiveTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 130, 130, 130),
              ),
            ),
            SizedBox(width: context.adaptiveSize(12)),
            Icon(
              Icons.arrow_forward_ios,
              size: context.adaptiveSize(14),
              color: const Color.fromARGB(255, 189, 189, 189),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookingButton() {
    return CustomTextFieldWithGradientButton(
      text: "${_excursion.price.cleanFormat()} € / person",
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: BaseColors.text,
      ),
    );
  }
}

extension CleanDoubleFormat on double {
  String cleanFormat() => toStringAsFixed(2).replaceAll('.00', '');
}
