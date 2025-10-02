import 'vehicle.dart';

class Car extends Vehicle {
  final String brand;
  final int pricePerHour;
  final int maxSpeed;
  final String image;
  final int year;
  final String type_transmission;
  final int number_seats;
  final String type_fuel;
  final String insurance;
  Car({
    required this.brand,
    required this.pricePerHour,
    required this.maxSpeed,
    required this.image,
    required this.year,
    required this.type_transmission,
    required this.number_seats,
    required this.type_fuel,
    required this.insurance,
    required int price,
    required String model,
    required String speed,
  });
}
