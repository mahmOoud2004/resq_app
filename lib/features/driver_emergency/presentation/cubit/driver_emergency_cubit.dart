import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_state.dart';

import '../../data/repositories/driver_emergency_repository.dart';

class DriverEmergencyCubit extends Cubit<DriverEmergencyState> {
  final DriverEmergencyRepository repository = DriverEmergencyRepository();
  bool _isOnline = true;

  DriverEmergencyCubit() : super(const DriverEmergencyInitial(isOnline: true));

  bool get isOnline => _isOnline;

  Future<void> setAvailability(bool value) async {
    _isOnline = value;

    if (!_isOnline) {
      emit(const DriverEmergencyLoaded([], isOnline: false));
      return;
    }

    await loadRequests();
  }

  Future<void> loadRequests() async {
    if (isClosed || !_isOnline) {
      if (!isClosed) {
        emit(const DriverEmergencyLoaded([], isOnline: false));
      }
      return;
    }

    emit(const DriverEmergencyLoading(isOnline: true));

    try {
      final requests = await repository.getRequests();
      if (!isClosed) {
        emit(DriverEmergencyLoaded(requests, isOnline: true));
      }
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Failed to load driver requests.',
        name: 'DriverEmergencyCubit',
        error: error,
        stackTrace: stackTrace,
      );
      if (!isClosed) {
        emit(DriverEmergencyError(
          isOnline: true,
          message: appException.userMessage,
        ));
      }
    }
  }

  Future<void> accept(int id) async {
    if (!_isOnline) {
      emit(const DriverEmergencyError(
        isOnline: false,
        message: 'You are offline and cannot accept requests.',
      ));
      return;
    }

    try {
      await repository.acceptRequest(id);
      if (!isClosed) {
        await loadRequests();
      }
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Failed to accept driver request.',
        name: 'DriverEmergencyCubit',
        error: error,
        stackTrace: stackTrace,
      );
      if (!isClosed) {
        emit(DriverEmergencyError(
          isOnline: _isOnline,
          message: appException.userMessage,
        ));
      }
    }
  }

  Future<void> cancel(int id) async {
    try {
      await repository.cancelRequest(id);
      if (!isClosed) {
        await loadRequests();
      }
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Failed to cancel driver request.',
        name: 'DriverEmergencyCubit',
        error: error,
        stackTrace: stackTrace,
      );
      if (!isClosed) {
        emit(DriverEmergencyError(
          isOnline: _isOnline,
          message: appException.userMessage,
        ));
      }
    }
  }

  Future<void> complete(int id) async {
    try {
      await repository.completeRequest(id);
      if (!isClosed) {
        await loadRequests();
      }
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Failed to complete driver request.',
        name: 'DriverEmergencyCubit',
        error: error,
        stackTrace: stackTrace,
      );
      if (!isClosed) {
        emit(DriverEmergencyError(
          isOnline: _isOnline,
          message: appException.userMessage,
        ));
      }
    }
  }
}
