import 'vehicle.dart';

class Motorcycle extends Vehicle {
  final int id;
  final String brand;
  final String model;
  final int year;
  final int maxSpeed;
  final int pricePerHour;
  final String image;
  final String type_transmission;
  final int number_seats;
  final String type_fuel;
  final String insurance;

  Motorcycle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.maxSpeed,
    required this.pricePerHour,
    required this.image,
    required this.type_transmission,
    required this.number_seats,
    required this.type_fuel,
    required this.insurance,
  });
}
