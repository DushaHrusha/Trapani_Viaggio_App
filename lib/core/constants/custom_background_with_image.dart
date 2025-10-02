import 'package:flutter/material.dart';
import 'package:trapani_viaggio_app/core/adaptive_size_extension.dart';
import 'package:trapani_viaggio_app/core/constants/base_colors.dart';

class CustomBackgroundWithImage extends StatelessWidget {
  final Image image;
  final List<Widget> children;

  const CustomBackgroundWithImage({
    super.key,
    required this.image,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image,
        Padding(
          // Используйте adaptivePadding для отступа
          padding: context.adaptivePadding(
            EdgeInsets.only(
              top: context.adaptiveSize(298), // Адаптивный размер отступа
            ),
          ),
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
              height:
                  MediaQuery.of(context).size.height -
                  context.adaptiveSize(298),
            ),
            child: SingleChildScrollView(
              // Добавлена прокрутка для контента
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
