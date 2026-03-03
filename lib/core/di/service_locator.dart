// import 'package:get_it/get_it.dart';
// import 'package:resq_app/core/network/dio_client.dart';
// import 'package:resq_app/core/storage/token_storage.dart';
// import 'package:resq_app/features/auth/data/datasource/auth_remote_datasource.dart';
// import 'package:resq_app/features/auth/data/repositories/auth_repository.dart';
// import 'package:resq_app/features/auth/domain/usecases/resend_otp_usecase.dart';
// import 'package:resq_app/features/auth/domain/usecases/verify_otp_usecase.dart';
// import 'package:resq_app/features/auth/presentation/cubit/otp/otp_cubit.dart';


// final sl = GetIt.instance;

// Future<void> init() async {

//   // storage
//   sl.registerLazySingleton(() => TokenStorage());

//   // dio
//   sl.registerLazySingleton(() => DioClient().dio);

//   // datasource
//   sl.registerLazySingleton(
//     () => AuthRemoteDataSource(sl()),
//   );

//   // repository
//   sl.registerLazySingleton(
//     () => AuthRepository(
//       sl(),
//       sl(),
//     ),
//   );

//   // usecases
//   sl.registerLazySingleton(
//     () => VerifyOtpUseCase(sl()),
//   );

//   sl.registerLazySingleton(
//     () => ResendOtpUseCase(sl()),
//   );

//   // cubit
//   sl.registerFactory(
//     () => OtpCubit(sl(), sl()),
//   );
// }