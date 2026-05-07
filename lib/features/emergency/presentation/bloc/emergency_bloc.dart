import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:resq_app/core/network/api_constants.dart';
import 'package:resq_app/core/network/dio_client.dart';
import 'package:resq_app/features/emergency/data/model/active_request_mode.dart';
import 'package:resq_app/features/emergency/domain/usecase/create_emergency_usecase.dart';

part 'emergency_event.dart';
part 'emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final CreateEmergencyUseCase createEmergency;
  final dio = DioClient().dio;

  EmergencyBloc(this.createEmergency) : super(EmergencyInitial()) {
    on<SendEmergencyEvent>(_sendEmergency);
    on<GetActiveRequestEvent>(_getActiveRequest);
  }

  Future<void> _sendEmergency(
    SendEmergencyEvent event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(EmergencyLoading());

    try {
      await createEmergency(
        serviceType: event.serviceType,
        lat: event.lat,
        lng: event.lng,
      );

      add(GetActiveRequestEvent()); // 🔥 بعد الإنشاء اسحب الداتا
    } catch (e) {
      emit(EmergencyError(e.toString()));
    }
  }

  Future<void> _getActiveRequest(
    GetActiveRequestEvent event,
    Emitter<EmergencyState> emit,
  ) async {
    try {
      final response = await dio.get(ApiConstants.getActiveRequest);

      final data = response.data;

      if (data["has_active_request"] == true) {
        final request = ActiveRequestModel.fromJson(data["request_details"]);

        /// 🔥 حالة إنهاء الطلب
        if (request.status == "completed") {
          emit(EmergencyCompleted());
          return;
        }

        /// 🔥 حالة الإلغاء
        if (request.status == "cancelled") {
          emit(EmergencyInitial());
          return;
        }

        /// باقي الحالات (pending / accepted / on_way)
        emit(EmergencyHasActiveRequest(request));
      } else {
        emit(EmergencyInitial());
      }
    } catch (e) {
      emit(EmergencyError(e.toString()));
    }
  }
}
