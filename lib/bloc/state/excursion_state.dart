import '../../data/models/excursion_model.dart';

abstract class ExcursionState {}

class ExcursionInitial extends ExcursionState {}

class ExcursionLoaded extends ExcursionState {
  final List<Excursion> excursions;

  ExcursionLoaded(this.excursions);
}
