import 'package:flutter/material.dart';

abstract class CardData {
  final String title;
  final List<String> imageUrl;
  final String description;
  final double rating;
  final double price;
  final List<IconData> iconServices;

  final int id;

  CardData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.price,
    required this.iconServices,
  });
}
