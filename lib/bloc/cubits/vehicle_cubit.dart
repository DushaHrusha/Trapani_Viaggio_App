import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trapani_viaggio_app/bloc/state/vehicle_state.dart';
import 'package:trapani_viaggio_app/data/repositories/vehicle_repository.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleInitial());
  void loadExcursions(VehicleRepository repository) {
    try {
      final vehicles = repository.vehicles;
      print(vehicles.length);
      emit(new VehicleLoaded(vehicles));
    } catch (e) {
      print("Error loading vehicles: $e");
    }
  }
}
