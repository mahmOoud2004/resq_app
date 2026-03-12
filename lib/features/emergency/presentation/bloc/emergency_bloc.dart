import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/features/emergency/domain/usecase/create_emergency_usecase.dart';

part 'emergency_event.dart';
part 'emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final CreateEmergencyUseCase createEmergency;

  EmergencyBloc(this.createEmergency) : super(EmergencyInitial()) {
    on<SendEmergencyEvent>((event, emit) async {
      emit(EmergencyLoading());

      try {
        await createEmergency(
          serviceType: event.serviceType,
          lat: event.lat,
          lng: event.lng,
        );
        print("Request sent successfully");

        emit(EmergencySuccess());
      } catch (e) {
        emit(EmergencyError(e.toString()));
      }
    });
  }
}
