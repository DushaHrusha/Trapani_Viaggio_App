import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/apartment.dart';
import '../../data/repositories/apartments_repository.dart';
import '../state/apartments_state.dart';

class ApartmentCubit extends Cubit<ApartmentsState> {
  ApartmentCubit() : super(ApartmentsInitial()) {
    final ApartmentsRepository apartmentsRepository = ApartmentsRepository();
    List<Apartment> apartments = apartmentsRepository.apartments;
    emit(ApartmentsLoaded(apartments));
  }
}
