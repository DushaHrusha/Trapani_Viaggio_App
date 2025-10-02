import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/adaptive_size_extension.dart';
import '../bloc/cubits/bookmarks_cubit.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_app_bar.dart';
import '../core/constants/custom_background_with_gradient.dart';
import '../core/constants/custom_text_field_with_gradient_button.dart';
import '../core/constants/grey_line.dart';
import '../data/models/apartment.dart';
import '../data/models/bookmark.dart';
import 'dates_guests_screen.dart';

class ApartmentDetailScreen extends StatefulWidget {
  final Apartment apartment;
  const ApartmentDetailScreen({super.key, required this.apartment});

  @override
  State<ApartmentDetailScreen> createState() => _ApartmentDetailScreenState();
}

class _ApartmentDetailScreenState extends State<ApartmentDetailScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  final _scrollController = ScrollController();

  late final AnimationController _animController;
  late final List<IconData> _icons;
  int _imagePage = 0;
  int _iconPage = 0;

  @override
  void initState() {
    super.initState();
    _icons = widget.apartment.iconServices;
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _imagePage) setState(() => _imagePage = page);
    });

    _animController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Animation<T> _buildAnimation<T>(
    T begin,
    T end,
    double start,
    double finish,
    Curve curve,
  ) {
    return Tween<T>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(start, finish, curve: curve),
      ),
    );
  }

  void _scrollIcons(bool isRight) {
    setState(() {
      _iconPage = (_iconPage + (isRight ? 1 : -1)).clamp(0, _icons.length - 5);
      _scrollController.animateTo(
        _iconPage * 80.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildDateGuestSelector() {
    final textStyle = context.adaptiveTextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: BaseColors.text,
    );

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => DatesGuestsScreen(),
      ),
      child: Row(
        children: [
          _buildSelectorHalf("19 -21 Aug `20", textStyle, isLeft: true),
          _buildSelectorHalf("2 adualts + 1 child", textStyle, isLeft: false),
        ],
      ),
    );
  }

  Widget _buildSelectorHalf(
    String text,
    TextStyle style, {
    required bool isLeft,
  }) {
    return Expanded(
      child: Container(
        height: context.adaptiveSize(40),
        decoration: BoxDecoration(
          border: Border.all(color: BaseColors.line),
          borderRadius: BorderRadius.horizontal(
            left: isLeft
                ? Radius.circular(context.adaptiveSize(32))
                : Radius.zero,
            right: !isLeft
                ? Radius.circular(context.adaptiveSize(32))
                : Radius.zero,
          ),
        ),
        child: Center(child: Text(text, style: style)),
      ),
    );
  }

  Widget _buildImageCarousel() {
    final apartment = widget.apartment;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.adaptiveSize(32)),
          child: SizedBox(
            height: context.adaptiveSize(180),
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: apartment.imageUrl.length,
              itemBuilder: (_, i) =>
                  Image.asset(apartment.imageUrl[i], fit: BoxFit.cover),
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
          child: _buildIndicator(apartment.imageUrl.length),
        ),
      ],
    );
  }

  Widget _buildBookmarkButton() {
    return BlocBuilder<BookmarksCubit, List<Bookmark>>(
      builder: (context, _) {
        final cubit = context.read<BookmarksCubit>();
        final isBookmarked = cubit.isBookmarked(widget.apartment);

        return GestureDetector(
          onTap: () => cubit.toggleBookmark(widget.apartment),
          child: Container(
            height: context.adaptiveSize(56),
            width: context.adaptiveSize(56),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.adaptiveSize(16)),
              color: Color.fromARGB(87, 255, 255, 255),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.adaptiveSize(16)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                  color: isBookmarked
                      ? BaseColors.accent
                      : Color.fromARGB(255, 251, 251, 253),
                  size: context.adaptiveSize(25),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _imagePage == i ? BaseColors.accent : BaseColors.background,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    final apartment = widget.apartment;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            apartment.title,
            style: context
                .adaptiveTextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: BaseColors.text,
                )
                .copyWith(height: 1.4),
          ),
        ),
        SizedBox(width: context.adaptiveSize(24)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Per night:",
              style: context
                  .adaptiveTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: BaseColors.text,
                  )
                  .copyWith(height: 1),
            ),
            SizedBox(height: context.adaptiveSize(5)),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  apartment.price.toStringAsFixed(0),
                  style: context
                      .adaptiveTextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: BaseColors.accent,
                      )
                      .copyWith(height: 1),
                ),
                Text(
                  " €",
                  style: context
                      .adaptiveTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: BaseColors.accent,
                      )
                      .copyWith(height: 1),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconsScroll() {
    return Row(
      children: [
        if (_iconPage > 0)
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: context.adaptiveSize(16)),
            onPressed: () => _scrollIcons(false),
          ),
        Expanded(
          child: SizedBox(
            height: context.adaptiveSize(48),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _icons.length,
              itemBuilder: (_, i) => Container(
                margin: EdgeInsets.only(right: context.adaptiveSize(12)),
                height: context.adaptiveSize(48),
                width: context.adaptiveSize(46),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color.fromARGB(255, 224, 224, 224)),
                ),
                child: Icon(
                  _icons[i],
                  color: BaseColors.text,
                  size: context.adaptiveSize(20),
                ),
              ),
            ),
          ),
        ),
        if (_iconPage < _icons.length - 5)
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: context.adaptiveSize(12),
              color: Color.fromARGB(255, 189, 189, 189),
            ),
            onPressed: () => _scrollIcons(true),
          ),
      ],
    );
  }

  Widget _buildRatingSection() {
    final apartment = widget.apartment;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              apartment.rating.toString(),
              style: context.adaptiveTextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: BaseColors.accent,
              ),
            ),
            SizedBox(width: context.adaptiveSize(6)),
            StarRating(rating: apartment.rating),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${apartment.numberReviews} guest reviews",
              style: context.adaptiveTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 130, 130, 130),
              ),
            ),
            SizedBox(width: context.adaptiveSize(12)),
            Icon(
              Icons.arrow_forward_ios,
              size: context.adaptiveSize(14),
              color: Color.fromARGB(255, 189, 189, 189),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final fadeAnim = _buildAnimation<double>(
      0.0,
      1.0,
      0.2,
      0.5,
      Curves.easeInOut,
    );
    final cardsAnim = _buildAnimation<double>(
      0.0,
      1.0,
      0.5,
      1.0,
      Curves.easeInOut,
    );
    final slideAnim = _buildAnimation<Offset>(
      Offset(0, 1),
      Offset.zero,
      0.5,
      0.7,
      Curves.easeOutQuad,
    );

    return Scaffold(
      body: CustomBackgroundWithGradient(
        child: Column(
          children: [
            FadeTransition(
              opacity: fadeAnim,
              child: Column(
                children: [
                  CustomAppBar(label: "apartments"),
                  GreyLine(),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FadeTransition(
                opacity: cardsAnim,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  children: [
                    _buildDateGuestSelector(),
                    SizedBox(height: context.adaptiveSize(16)),
                    _buildImageCarousel(),
                    SizedBox(height: context.adaptiveSize(12)),
                    _buildTitleAndPrice(),
                    SizedBox(height: context.adaptiveSize(16)),
                    Text(
                      widget.apartment.description,
                      style: context.adaptiveTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 130, 130, 130),
                      ),
                    ),
                    SizedBox(height: context.adaptiveSize(24)),
                    _buildIconsScroll(),
                    SizedBox(height: context.adaptiveSize(40)),
                    GreyLine(),
                    SizedBox(height: context.adaptiveSize(24)),
                    _buildRatingSection(),
                    SizedBox(height: context.adaptiveSize(24)),
                    GreyLine(),
                    SizedBox(height: context.adaptiveSize(40)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        context.adaptiveSize(22),
                      ),
                      child: Container(height: 100, color: BaseColors.primary),
                    ),
                    SizedBox(height: context.adaptiveSize(16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address:',
                          style: context.adaptiveTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 109, 109, 109),
                          ),
                        ),
                        SizedBox(
                          width: context.adaptiveSize(167),
                          child: Text(
                            widget.apartment.address,
                            style: context.adaptiveTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 109, 109, 109),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.adaptiveSize(40)),
                    CustomTextFieldWithGradientButton(
                      text: "278 € / 2 days",
                      style: context.adaptiveTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: BaseColors.text,
                      ),
                    ),
                    SizedBox(height: context.adaptiveSize(20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SlideTransition(
        position: slideAnim,
        child: BottomBar(currentScreen: widget),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final filledStars = (rating / 2).round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < filledStars ? Icons.star_rounded : Icons.star_border_rounded,
          color: BaseColors.accent,
          size: 22,
        ),
      ),
    );
  }
}
