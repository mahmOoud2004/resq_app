import '../repositories/admin_repository.dart';

class RejectUser {
  final AdminRepository repository;

  RejectUser(this.repository);

  Future call(int id) {
    return repository.blockUser(id);
  }
}
