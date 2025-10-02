import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trapani_viaggio_app/core/adaptive_size_extension.dart';

class CustomGradientButton extends StatelessWidget {
  final String text;
  final String path;
  const CustomGradientButton({
    super.key,
    required this.text,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(context.adaptiveSize(30)),
        splashColor: Colors.white.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        onTap: () {
          context.go(path);
        },
        child: Container(
          height: context.adaptiveSize(56),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 127, 80),
                Color.fromARGB(255, 85, 97, 178),
              ],
              begin: AlignmentGeometry.directional(-2, -3),
            ),
            borderRadius: BorderRadius.circular(context.adaptiveSize(30)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(127, 255, 175, 175),
                spreadRadius: 0,
                blurRadius: context.adaptiveSize(20),
                offset: Offset(
                  context.adaptiveSize(-5),
                  context.adaptiveSize(-5),
                ),
              ),
              BoxShadow(
                color: Color.fromARGB(127, 132, 147, 197),
                spreadRadius: 0,
                blurRadius: context.adaptiveSize(20),
                offset: Offset(
                  context.adaptiveSize(3),
                  context.adaptiveSize(3),
                ),
              ),
            ],
          ),
          child: Text(
            text,
            style: context.adaptiveTextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
