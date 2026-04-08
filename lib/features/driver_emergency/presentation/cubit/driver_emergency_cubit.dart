import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_state.dart';

import '../../data/repositories/driver_emergency_repository.dart';

class DriverEmergencyCubit extends Cubit<DriverEmergencyState> {
  final DriverEmergencyRepository repository = DriverEmergencyRepository();

  DriverEmergencyCubit() : super(DriverEmergencyInitial());

  Future<void> loadRequests() async {
    if (isClosed) return;

    emit(DriverEmergencyLoading());

    try {
      final requests = await repository.getRequests();

      if (!isClosed) {
        emit(DriverEmergencyLoaded(requests));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DriverEmergencyError());
      }
    }
  }

  Future<void> accept(int id) async {
    await repository.acceptRequest(id);

    if (!isClosed) {
      loadRequests();
    }
  }

  Future<void> cancel(int id) async {
    await repository.cancelRequest(id);
    loadRequests();
  }

  Future<void> complete(int id) async {
    await repository.completeRequest(id);

    if (!isClosed) {
      loadRequests();
    }
  }
}
