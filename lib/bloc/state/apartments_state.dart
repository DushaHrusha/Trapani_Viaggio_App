import '../../data/models/apartment.dart';

abstract class ApartmentsState {}

class ApartmentsInitial extends ApartmentsState {}

class ApartmentsLoaded extends ApartmentsState {
  final List<Apartment> apartments;

  ApartmentsLoaded(this.apartments);
}
