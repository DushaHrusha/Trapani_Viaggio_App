import '../models/motorcycle.dart';
import '../models/vehicle.dart';
import 'vehicle_repository.dart';

class MotorcycleRepository extends VehicleRepository {
  final List<Vehicle> vehicles = [
    Motorcycle(
      id: 1,
      brand: 'Ducati Diavel',
      model: 'Ducati Diavel',
      year: 2018,
      maxSpeed: 160,
      pricePerHour: 59,
      image: 'assets/images/fcbcf1f065cc46fdb291e2af47feae0483f041dd.png',
      type_transmission: '6 gears',
      number_seats: 2,
      type_fuel: 'Gasoline',
      insurance: 'Insurance',
    ),
    Motorcycle(
      id: 2,
      brand: 'Kawasaki',
      model: 'Ninja',
      year: 2014,
      maxSpeed: 160,
      pricePerHour: 37,
      image: 'assets/images/f74f89877d81bd9981d64a07a76e102401ca499b.png',
      type_transmission: '6 gears',
      number_seats: 2,
      type_fuel: 'Gasoline',
      insurance: 'Insurance',
    ),
  ];
}
