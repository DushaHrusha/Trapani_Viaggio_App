import '../models/car.dart';
import '../models/vehicle.dart';
import 'vehicle_repository.dart';

class CarsRepository extends VehicleRepository {
  final List<Vehicle> vehicles = [
    Car(
      image: 'assets/images/car2.png',
      model: 'Fiat 500',
      year: 2015,
      price: 49,
      speed: '140 km/h',
      brand: 'Fiat 500',
      pricePerHour: 49,
      maxSpeed: 140,
      type_transmission: 'Automatic',
      number_seats: 4,
      type_fuel: 'Gasoline',
      insurance: 'Insurance',
    ),
    Car(
      image: 'assets/images/car1.png',
      model: 'Alfa Romeo Giulietta',
      year: 2017,
      price: 54,
      speed: '230 km/h',
      brand: 'EliteDrive',
      pricePerHour: 54,
      maxSpeed: 230,
      type_transmission: 'Automatic',
      number_seats: 4,
      type_fuel: 'Gasoline',
      insurance: 'Insurance',
    ),
  ];
}
