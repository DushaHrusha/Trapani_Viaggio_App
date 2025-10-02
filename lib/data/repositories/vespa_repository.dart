import '../models/vehicle.dart';
import '../models/vespa_bike.dart';
import 'vehicle_repository.dart';

class VespaRepository extends VehicleRepository {
  final List<Vehicle> vehicles = [
    VespaBike(
      id: 1,
      brand: 'Vespa GTS',
      model: 'Vespa GTS',
      year: 2018,
      maxSpeed: 122,
      pricePerHour: 39,
      image: 'assets/images/f8eb6b5fc00a14f53d9d89985199567836416c69.png',
      type_transmission: 'Automatic',
      number_seats: 2,
      type_fuel: 'Gasoline',
      insurance: 'Insurance',
    ),
    VespaBike(
      id: 2,
      brand: 'Vespa Primavera',
      model: 'Vespa Primavera',
      year: 2017,
      maxSpeed: 120,
      pricePerHour: 31,
      image: 'assets/images/ab66fb1b19e15b25fab85ec4603d8e2b855f8a74.png',
      type_transmission: 'Automatic',
      number_seats: 2,
      type_fuel: 'Gasoline',
      insurance: 'Insurance',
    ),
  ];
}
