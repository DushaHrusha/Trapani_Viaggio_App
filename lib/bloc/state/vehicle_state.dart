import '../../data/models/vehicle.dart';

abstract class VehicleState {}

class VehicleInitial extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;

  VehicleLoaded(this.vehicles);
}
