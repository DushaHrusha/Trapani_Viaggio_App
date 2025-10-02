import 'package:flutter/widgets.dart';
import 'card_data.dart';

class Excursion implements CardData {
  final int id;
  final String title;
  final List<String> imageUrl;
  final String description;
  final double price;
  final double rating;
  final List<IconData> iconServices;
  final int numberReviews;
  final String address;
  final DateTime startingTime;
  final int duration;
  final List<String> sights;
  final List<String> notIncluded;
  final String transfer;
  final String takeWithYou;
  Excursion({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.rating,
    required this.iconServices,
    required this.numberReviews,
    required this.address,
    required this.duration,
    required this.startingTime,
    required this.sights,
    required this.notIncluded,
    required this.transfer,
    required this.takeWithYou,
  });
}
