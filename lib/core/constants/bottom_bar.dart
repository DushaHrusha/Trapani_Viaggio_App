import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trapani_viaggio_app/core/adaptive_size_extension.dart';
import '../../presentation/bookmarks.dart';
import '../../presentation/main_menu_screen.dart';
import '../../presentation/profile_screen.dart';
import '../../presentation/splash_screen.dart';
import 'base_colors.dart';

class BottomBar extends StatefulWidget {
  final Widget currentScreen;

  const BottomBar({super.key, required this.currentScreen});

  @override
  createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: context.adaptiveSize(64),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.adaptiveSize(20)),
          topRight: Radius.circular(context.adaptiveSize(20)),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(190, 190, 190, 0.3),
            spreadRadius: context.adaptiveSize(5),
            blurRadius: context.adaptiveSize(100),
            offset: Offset(0, context.adaptiveSize(-10)),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.adaptiveSize(32)),
          topRight: Radius.circular(context.adaptiveSize(32)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 251, 251, 253),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          iconSize: context.adaptiveSize(24),
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: [
            _buildNavItem(
              'assets/icons/home.svg',
              widget.currentScreen is MainMenuScreen,
            ),
            _buildNavItem(
              'assets/icons/map.svg',
              widget.currentScreen is SplashScreen,
            ),
            _buildNavItem(
              'assets/icons/bookmark.svg',
              widget.currentScreen is BookmarksScreen,
            ),
            _buildNavItem(
              'assets/icons/user.svg',
              widget.currentScreen is ProfileScreen,
            ),
          ],
          onTap: (index) {
            _navigateToScreen(index);
          },
        ),
      ),
    );
  }

  void _navigateToScreen(int index) {
    String targetScreen;
    switch (index) {
      case 0:
        targetScreen = "/home";
        break;
      case 1:
        targetScreen = "/";
        break;
      case 2:
        targetScreen = "/bookmarks";
        break;
      case 3:
        targetScreen = "/profile";
        break;
      default:
        targetScreen = "/";
    }

    context.go(targetScreen);
  }

  BottomNavigationBarItem _buildNavItem(String icon, bool isActive) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(top: context.adaptiveSize(0)), //20
        child: SvgPicture.asset(
          icon,
          width: context.adaptiveSize(24),
          height: context.adaptiveSize(24),
          color: isActive ? BaseColors.accent : null,
        ),
      ),
      label: '',
    );
  }
}
