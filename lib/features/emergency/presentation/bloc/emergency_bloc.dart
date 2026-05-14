import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
import 'package:resq_app/core/network/api_constants.dart';
import 'package:resq_app/core/network/dio_client.dart';
import 'package:resq_app/features/emergency/data/model/active_request_mode.dart';
import 'package:resq_app/features/emergency/domain/usecase/create_emergency_usecase.dart';

part 'emergency_event.dart';
part 'emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final CreateEmergencyUseCase createEmergency;
  final dio = DioClient().dio;

  bool _isFetchingActiveRequest = false;
  bool _isSendingRequest = false;

  EmergencyBloc(this.createEmergency) : super(EmergencyInitial()) {
    on<SendEmergencyEvent>(_sendEmergency);
    on<GetActiveRequestEvent>(_getActiveRequest);
  }

  Future<void> _sendEmergency(
    SendEmergencyEvent event,
    Emitter<EmergencyState> emit,
  ) async {
    if (_isSendingRequest) {
      return;
    }

    _isSendingRequest = true;
    emit(EmergencyLoading());

    try {
      await createEmergency(
        serviceType: event.serviceType,
        lat: event.lat,
        lng: event.lng,
      );

      add(GetActiveRequestEvent(forceRefresh: true));
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Failed to create emergency request.',
        name: 'EmergencyBloc',
        error: error,
        stackTrace: stackTrace,
      );
      emit(EmergencyError(appException.userMessage));
    } finally {
      _isSendingRequest = false;
    }
  }

  Future<void> _getActiveRequest(
    GetActiveRequestEvent event,
    Emitter<EmergencyState> emit,
  ) async {
    if (_isFetchingActiveRequest && !event.forceRefresh) {
      return;
    }

    _isFetchingActiveRequest = true;

    try {
      final response = await dio.get(ApiConstants.getActiveRequest);
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Active request response is invalid.');
      }

      if (data["has_active_request"] == true) {
        final requestDetails = data["request_details"];
        if (requestDetails is! Map<String, dynamic>) {
          throw const FormatException('Request details are invalid.');
        }

        final request = ActiveRequestModel.fromJson(requestDetails);
        if (request.status == "completed") {
          emit(EmergencyCompleted());
          return;
        }

        if (request.status == "cancelled") {
          emit(EmergencyInitial());
          return;
        }

        emit(EmergencyHasActiveRequest(request));
      } else {
        emit(EmergencyInitial());
      }
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Failed to fetch active emergency request.',
        name: 'EmergencyBloc',
        error: error,
        stackTrace: stackTrace,
      );
      emit(EmergencyError(appException.userMessage));
    } finally {
      _isFetchingActiveRequest = false;
    }
  }
}
