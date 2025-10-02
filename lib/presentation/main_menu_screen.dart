import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/adaptive_size_extension.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_background_with_image.dart';
import '../core/constants/custom_gradient_button.dart';
import '../core/constants/grey_line.dart';
import '../core/routing/app_routes.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  static const _menuItems = [
    _MenuItem(icon: 'exclamation', label: 'City info'),
    _MenuItem(icon: 'paths', label: 'Places'),
    _MenuItem(icon: 'star', label: 'Events'),
    _MenuItem(icon: 'gallery', label: 'Gallery'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackgroundWithImage(
        image: _buildHeaderImage(context),
        children: [
          SizedBox(height: context.adaptiveSize(38)),
          _buildWelcomeSection(context),
          SizedBox(height: context.adaptiveSize(40)),
          _buildServicesButton(context),
          SizedBox(height: context.adaptiveSize(32)),
          _buildDivider(context),
          SizedBox(height: context.adaptiveSize(32)),
          _buildMenuGrid(context),
          SizedBox(height: context.adaptiveSize(30)),
        ],
      ),
      bottomNavigationBar: BottomBar(currentScreen: this),
    );
  }

  Image _buildHeaderImage(BuildContext context) {
    return Image.asset(
      'assets/images/city_header.jpg',
      height: context.adaptiveSize(400),
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      children: [
        Text(
          'Hello. Welcome to Trapani!',
          textAlign: TextAlign.center,
          style: context.adaptiveTextStyle(
            fontSize: 22,
            fontFamily: 'Berlin Sans FB',
            fontWeight: FontWeight.w400,
            color: BaseColors.text,
          ),
        ),
        SizedBox(height: context.adaptiveSize(16)),
        Padding(
          padding: context.adaptivePadding(
            const EdgeInsets.symmetric(horizontal: 30),
          ),
          child: Text(
            'Place with a lively atmosphere due to its position as the capital and its economic activities as a port.',
            textAlign: TextAlign.center,
            style: context.adaptiveTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: BaseColors.text,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesButton(BuildContext context) {
    return Padding(
      padding: context.adaptivePadding(
        const EdgeInsets.symmetric(horizontal: 30),
      ),
      child: const CustomGradientButton(text: 'Services', path: AppRouter.menu),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.adaptiveSize(30)),
      child: GreyLine(),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: context.adaptiveSize(23),
        crossAxisSpacing: context.adaptiveSize(23),
        childAspectRatio: 2.6,
      ),
      padding: context.adaptivePadding(
        const EdgeInsets.symmetric(horizontal: 30),
      ),
      itemCount: _menuItems.length,
      itemBuilder: (context, index) =>
          _buildGridButton(context, _menuItems[index]),
    );
  }

  Widget _buildGridButton(BuildContext context, _MenuItem item) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: BaseColors.backgroundCircles,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.adaptiveSize(32)),
        ),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/${item.icon}.svg",
            color: BaseColors.secondary,
            width: context.adaptiveSize(24),
            height: context.adaptiveSize(24),
          ),
          SizedBox(width: context.adaptiveSize(13)),
          Text(
            item.label,
            style: context.adaptiveTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: BaseColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String icon;
  final String label;

  const _MenuItem({required this.icon, required this.label});
}
