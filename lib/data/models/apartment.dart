import 'package:flutter/material.dart';
import 'card_data.dart';

class Apartment implements CardData {
  final String title;
  final List<String> imageUrl;
  final String description;
  final double price;
  final List<IconData> iconServices;
  final double rating;
  final int numberReviews;
  final String address;
  final int id;

  Apartment({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.iconServices,
    required this.rating,
    required this.numberReviews,
    required this.address,
  });
}
