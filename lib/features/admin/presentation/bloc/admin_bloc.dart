import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/error/error_handler.dart';

import '../../data/datasources/admin_remote_datasource.dart';
import '../../data/models/admin_stats_model.dart';
import '../../data/models/emergency_model.dart';
import '../../data/models/pending_user_model.dart';
import '../../data/repositories/admin_repository_impl.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final repository = AdminRepositoryImpl(AdminRemoteDatasource());

  AdminBloc() : super(AdminInitial()) {
    on<LoadDashboard>((event, emit) async {
      emit(AdminLoading());

      try {
        final statsResponse = await repository.getStats();
        final stats = AdminStatsModel.fromJson(statsResponse.data);

        final emergencyResponse = await repository.getEmergencies();
        final emergencies = (emergencyResponse.data["emergencies"] as List)
            .map((e) => EmergencyModel.fromJson(e))
            .toList();

        emit(AdminDashboardLoaded(stats: stats, emergencies: emergencies));
      } catch (error, stackTrace) {
        final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
        emit(AdminError(appException.userMessage));
      }
    });

    on<LoadPendingUsers>((event, emit) async {
      emit(AdminLoading());

      try {
        final response = await repository.getPendingUsers();
        final users = (response.data["users"] as List)
            .map((e) => PendingUserModel.fromJson(e))
            .toList();

        emit(AdminUsersLoaded(users));
      } catch (error, stackTrace) {
        final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
        emit(AdminError(appException.userMessage));
      }
    });

    on<ApproveUserEvent>((event, emit) async {
      await repository.approveUser(event.id);
      add(LoadPendingUsers());
    });

    on<RejectUserEvent>((event, emit) async {
      await repository.blockUser(event.id);
      add(LoadPendingUsers());
    });

    on<LoadAllUsers>((event, emit) async {
      emit(AdminLoading());

      try {
        final response = await repository.getAllUsers();
        final users = (response.data["data"]["data"] as List)
            .map((e) => PendingUserModel.fromJson(e))
            .toList();

        emit(AdminUsersLoaded(users));
      } catch (error, stackTrace) {
        final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
        emit(AdminError(appException.userMessage));
      }
    });

    on<CancelEmergencyEvent>((event, emit) async {
      await repository.cancelEmergency(event.id);
      add(LoadDashboard());
    });
  }
}
