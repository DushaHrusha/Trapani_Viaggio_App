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

class SecondCard extends StatelessWidget {
  final CardData data;
  final TextStyle style;
  final int index;

  static const _borderColor = Color.fromARGB(255, 224, 224, 224);
  static const _bookmarkBgColor = Color.fromARGB(87, 255, 255, 255);
  static const _bookmarkIconColor = Color.fromARGB(255, 251, 251, 253);

  const SecondCard({
    super.key,
    required this.index,
    required this.style,
    required this.data,
  });

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
          _buildMainCard(context),
          SizedBox(height: context.adaptiveSize(21)),
          CustomTextFieldWithGradientButton(
            text: "${data.price.toStringAsFixed(0)} €",
            style: style,
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.adaptiveSize(32)),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          _buildImageWithBookmark(context),
          SizedBox(height: context.adaptiveSize(16)),
          _buildCardInfo(context),
          SizedBox(height: context.adaptiveSize(21)),
        ],
      ),
    );
  }

  Widget _buildImageWithBookmark(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.adaptiveSize(32)),
          ),
          child: Image.asset(
            data.imageUrl[0],
            height: context.adaptiveSize(177),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        _buildBookmarkButton(context),
      ],
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return Positioned(
      right: context.adaptiveSize(24),
      top: context.adaptiveSize(24),
      child: BlocBuilder<BookmarksCubit, List<Bookmark>>(
        builder: (context, bookmarks) {
          final cubit = context.read<BookmarksCubit>();
          final isBookmarked = cubit.isBookmarked(data);

          return GestureDetector(
            onTap: () => cubit.toggleBookmark(data),
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

  Widget _buildCardInfo(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: context.adaptiveSize(23));

    return Column(
      children: [
        Padding(
          padding: padding,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: context.adaptiveSize(8),
              runSpacing: context.adaptiveSize(8),
              children: [
                Text(
                  data.title,
                  softWrap: true,
                  style: context.adaptiveTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: BaseColors.text,
                  ),
                ),
                StarRating(rating: data.rating),
              ],
            ),
          ),
        ),
        SizedBox(height: context.adaptiveSize(12)),
        Padding(
          padding: padding,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _getFirstSentence(data.description),
              style: context.adaptiveTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: BaseColors.text,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
