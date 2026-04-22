import 'package:resq_app/features/admin/domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDatasource datasource;

  AdminRepositoryImpl(this.datasource);

  @override
  Future getStats() async {
    final response = await datasource.getStats();
    return response;
  }

  @override
  Future getPendingUsers() async {
    final response = await datasource.getPendingUsers();
    return response;
  }

  @override
  Future approveUser(int id) async {
    final response = await datasource.approveUser(id);
    return response;
  }

  @override
  Future blockUser(int id) async {
    final response = await datasource.blockUser(id);
    return response;
  }

  @override
  Future getEmergencies() async {
    final response = await datasource.getEmergencies();
    return response;
  }

  @override
  Future cancelEmergency(int id) async {
    final response = await datasource.cancelEmergency(id);
    return response;
  }

  @override
  Future getAllUsers() async {
    final response = await datasource.getAllUsers();
    return response;
  }
}
