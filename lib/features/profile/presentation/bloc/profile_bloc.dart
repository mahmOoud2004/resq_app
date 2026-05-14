import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/error/error_handler.dart';

import '../../data/repositories/profile_repository_impl.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepositoryImpl repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<GetProfileEvent>(_getProfile);
  }

  Future<void> _getProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await repository.getProfile();
      emit(ProfileLoaded(user));
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      emit(ProfileError(appException.userMessage));
    }
  }
}
