import 'package:flutter/material.dart';

extension AdaptiveSizeExtension on BuildContext {
  static const baseWidth = 390.0;
  static const baseHeight = 844.0;

  double get widthRatio => MediaQuery.of(this).size.width / baseWidth;
  double get heightRatio => MediaQuery.of(this).size.height / baseHeight;

  // Метод для получения адаптивного размера
  double adaptiveSize(
    double baseSize, {
    bool useWidth = true,
    double? maxSize,
    double? minSize,
  }) {
    double adaptedSize = baseSize * (useWidth ? widthRatio : heightRatio);

    // Опциональное ограничение размера
    if (maxSize != null) {
      adaptedSize = adaptedSize > maxSize ? maxSize : adaptedSize;
    }

    if (minSize != null) {
      adaptedSize = adaptedSize < minSize ? minSize : adaptedSize;
    }

    return adaptedSize;
  }

  // Получение адаптивных отступов
  EdgeInsets adaptivePadding(EdgeInsets basePadding, {bool useWidth = true}) {
    return EdgeInsets.only(
      left: adaptiveSize(basePadding.left, useWidth: useWidth),
      right: adaptiveSize(basePadding.right, useWidth: useWidth),
      top: adaptiveSize(basePadding.top, useWidth: useWidth),
      bottom: adaptiveSize(basePadding.bottom, useWidth: useWidth),
    );
  }

  // Получение адаптивного TextStyle
  TextStyle adaptiveTextStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: adaptiveSize(fontSize),
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
    );
  }
}
