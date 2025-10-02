import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trapani_viaggio_app/core/adaptive_size_extension.dart';
import 'package:trapani_viaggio_app/core/constants/base_colors.dart';

import '../../bloc/cubits/bookmarks_cubit.dart';
import '../../data/models/bookmark.dart';
import '../../data/models/card_data.dart';
import '../../presentation/apartment_detail_screen.dart';
import 'custom_text_field_with_gradient_button.dart';

class FirstCard extends StatefulWidget {
  final CardData data;
  final int index;
  final TextStyle style;

  const FirstCard({
    super.key,
    required this.data,
    required this.index,
    required this.style,
  });

  @override
  createState() => _FirstCardState();
}

class _FirstCardState extends State<FirstCard> {
  static const _borderColor = Color.fromARGB(255, 224, 224, 224);
  static const _iconColor = Color.fromARGB(255, 189, 189, 189);
  static const _bookmarkBgColor = Color.fromARGB(87, 255, 255, 255);
  static const _bookmarkIconColor = Color.fromARGB(255, 251, 251, 253);

  late final PageController _imageController;
  late final ScrollController _iconController;
  late final List<IconData> _icons;

  int _currentImagePage = 0;
  int _currentIconPage = 0;

  @override
  void initState() {
    super.initState();
    _imageController = PageController()
      ..addListener(
        () => setState(() {
          _currentImagePage = _imageController.page!.round();
        }),
      );
    _iconController = ScrollController();
    _icons = widget.data.iconServices;
  }

  @override
  void dispose() {
    _imageController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _scrollIcons(bool isRight) {
    final maxPage = _icons.length - 5;
    if ((isRight && _currentIconPage < maxPage) ||
        (!isRight && _currentIconPage > 0)) {
      setState(() {
        _currentIconPage += isRight ? 1 : -1;
        _iconController.animateTo(
          _currentIconPage * 80.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  String _getFirstSentence(String text) {
    final match = RegExp(r'^(.*?[.!?])').firstMatch(text);
    return match?.group(1)?.trim() ?? text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.adaptiveSize(44)),
      child: Column(
        children: [
          _buildMainCard(),
          SizedBox(height: context.adaptiveSize(24)),
          _buildIconsRow(),
          SizedBox(height: context.adaptiveSize(24)),
          CustomTextFieldWithGradientButton(
            text: "${widget.data.price.toStringAsFixed(0)} €",
            style: widget.style,
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.adaptiveSize(32)),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          _buildImageCarousel(),
          SizedBox(height: context.adaptiveSize(12)),
          _buildCardInfo(),
          SizedBox(height: context.adaptiveSize(21)),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.adaptiveSize(32)),
          ),
          child: SizedBox(
            height: context.adaptiveSize(375),
            width: double.infinity,
            child: PageView.builder(
              controller: _imageController,
              itemCount: widget.data.imageUrl.length,
              itemBuilder: (context, index) =>
                  Image.asset(widget.data.imageUrl[index], fit: BoxFit.cover),
            ),
          ),
        ),
        _buildBookmarkButton(),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildBookmarkButton() {
    return Positioned(
      right: context.adaptiveSize(24),
      top: context.adaptiveSize(24),
      child: BlocBuilder<BookmarksCubit, List<Bookmark>>(
        builder: (context, bookmarks) {
          final cubit = context.read<BookmarksCubit>();
          final isBookmarked = cubit.isBookmarked(widget.data);

          return GestureDetector(
            onTap: () => cubit.toggleBookmark(widget.data),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.adaptiveSize(16)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  height: context.adaptiveSize(56),
                  width: context.adaptiveSize(56),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      context.adaptiveSize(16),
                    ),
                    color: _bookmarkBgColor,
                  ),
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                    color: isBookmarked
                        ? BaseColors.accent
                        : _bookmarkIconColor,
                    size: context.adaptiveSize(25),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: context.adaptiveSize(16),
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.data.imageUrl.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentImagePage == index
                  ? BaseColors.accent
                  : BaseColors.background,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardInfo() {
    final horizontalPadding = EdgeInsets.symmetric(
      horizontal: context.adaptiveSize(23),
    );

    return Column(
      children: [
        Padding(
          padding: horizontalPadding,
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      widget.data.title,
                      softWrap: true,
                      style: context.adaptiveTextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: BaseColors.text,
                      ),
                    ),
                    StarRating(rating: widget.data.rating),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.adaptiveSize(12)),
        Padding(
          padding: horizontalPadding,
          child: Text(
            _getFirstSentence(widget.data.description),
            style: context.adaptiveTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: BaseColors.text,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildIconsRow() {
    return Row(
      children: [
        if (_currentIconPage > 0)
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: context.adaptiveSize(16)),
            onPressed: () => _scrollIcons(false),
          ),
        Expanded(child: _buildIconsList()),
        if (_currentIconPage < _icons.length - 5)
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: context.adaptiveSize(12),
              color: _iconColor,
            ),
            onPressed: () => _scrollIcons(true),
          ),
      ],
    );
  }

  Widget _buildIconsList() {
    return SizedBox(
      height: context.adaptiveSize(48),
      child: ListView.builder(
        controller: _iconController,
        scrollDirection: Axis.horizontal,
        itemCount: _icons.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(right: context.adaptiveSize(12)),
          height: context.adaptiveSize(48),
          width: context.adaptiveSize(46),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _borderColor),
          ),
          child: Icon(
            _icons[index],
            color: BaseColors.text,
            size: context.adaptiveSize(20),
          ),
        ),
      ),
    );
  }
}
