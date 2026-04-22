import '../repositories/admin_repository.dart';

class GetPendingUsers {
  final AdminRepository repository;

  GetPendingUsers(this.repository);

  Future call() {
    return repository.getPendingUsers();
  }
}
