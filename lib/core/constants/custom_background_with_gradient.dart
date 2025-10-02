import 'package:flutter/material.dart';
import 'package:trapani_viaggio_app/core/adaptive_size_extension.dart';
import 'package:trapani_viaggio_app/core/constants/base_colors.dart';

class CustomBackgroundWithGradient extends StatelessWidget {
  final Widget child;

  const CustomBackgroundWithGradient({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(255, 127, 80, 1),
            Color.fromRGBO(85, 97, 178, 1),
          ],
        ),
      ),
      child: Padding(
        padding: context.adaptivePadding(EdgeInsets.only(top: 58)),
        child: Container(
          decoration: BoxDecoration(
            color: BaseColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          constraints: BoxConstraints.expand(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          child: child,
        ),
      ),
    );
  }
}
