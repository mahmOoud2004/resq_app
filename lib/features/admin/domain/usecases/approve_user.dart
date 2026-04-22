import '../repositories/admin_repository.dart';

class ApproveUser {
  final AdminRepository repository;

  ApproveUser(this.repository);

  Future call(int id) {
    return repository.approveUser(id);
  }
}
