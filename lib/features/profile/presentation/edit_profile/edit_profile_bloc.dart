import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/features/profile/domain/repositories/profile_repository.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileRepository repository;

  EditProfileBloc(this.repository) : super(EditProfileInitial()) {
    on<UpdateProfileEvent>((event, emit) async {
      emit(EditProfileLoading());

      try {
        await repository.updateProfile(
          phone: event.phone,
          password: event.password,
          confirmPassword: event.confirmPassword,
          image: event.image,
        );

        emit(EditProfileSuccess());
      } catch (e) {
        emit(EditProfileError(e.toString()));
      }
    });
  }
}
