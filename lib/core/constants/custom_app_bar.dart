import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trapani_viaggio_app/core/adaptive_size_extension.dart';

class CustomAppBar extends StatelessWidget {
  final String label;

  const CustomAppBar({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.adaptiveSize(25),
        right: context.adaptiveSize(20),
        left: context.adaptiveSize(20),
        bottom: context.adaptiveSize(23),
      ),
      child: SizedBox(
        height: context.adaptiveSize(27),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/left.svg',
                height: context.adaptiveSize(24),
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: context.adaptiveSize(24),
                maxHeight: context.adaptiveSize(24),
              ),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go("/home");
                }
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: context.adaptiveSize(24),
                  fontFamily: 'Berlin Sans FB',
                  height: 1.0,
                  color: Color.fromARGB(255, 109, 109, 109),
                ),
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                height: context.adaptiveSize(24),
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: context.adaptiveSize(24),
                maxHeight: context.adaptiveSize(24),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
