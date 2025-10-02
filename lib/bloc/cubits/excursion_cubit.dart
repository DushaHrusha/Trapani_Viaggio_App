import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/excursion_model.dart';
import '../../data/repositories/excursions_repository.dart';
import '../state/excursion_state.dart';

class ExcursionCubit extends Cubit<ExcursionState> {
  ExcursionCubit() : super(ExcursionInitial()) {
    final ExcursionsRepository _excursionsRepository = ExcursionsRepository();
    List<Excursion> excursions = _excursionsRepository.excursions;
    emit(ExcursionLoaded(excursions));
  }
}
