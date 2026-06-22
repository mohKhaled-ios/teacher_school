// import 'package:get_it/get_it.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:teacher_management_app/features/exams/data/repositry/exam_repository_impl.dart';
// import 'package:teacher_management_app/features/exams/domain/repositry/exam_repositry.dart';
// import 'package:teacher_management_app/features/exams/presentation/cubite/cubite.dart';
// import 'package:teacher_management_app/features/grades/domain/grade_repository.dart';
// import 'package:teacher_management_app/features/grades/presentation/grade_cubit.dart';

// // Models/Adapters
// import 'package:teacher_management_app/features/materials/data/models/material_model.dart';
// import 'package:teacher_management_app/features/materials/data/models/subject_model.dart';
// import 'package:teacher_management_app/features/notfication/presentation/notification_cubit.dart';

// // Core
// import '../network/api_client.dart';
// import '../constants/hive_constants.dart';

// // Auth
// import '../../features/auth/data/datasources/auth_local_datasource.dart';
// import '../../features/auth/data/datasources/auth_remote_datasource.dart';
// import '../../features/auth/data/repositories/auth_repository_impl.dart';
// import '../../features/auth/domain/repositories/auth_repository.dart';
// import '../../features/auth/domain/usecases/login_usecase.dart';
// import '../../features/auth/presentation/cubit/auth_cubit.dart';

// // Attendance
// import '../../features/attendance/presentation/cubit/attendance_cubit.dart';

// // Materials
// import '../../features/materials/data/datasources/material_local_datasource.dart';
// import '../../features/materials/data/datasources/material_remote_datasource.dart';
// import '../../features/materials/data/models/class_model.dart';
// import '../../features/materials/data/repositories/material_repository_impl.dart';
// import '../../features/materials/domain/repositories/material_repository.dart';
// import '../../features/materials/domain/usecases/delete_material_usecase.dart';
// import '../../features/materials/domain/usecases/get_classes_usecase.dart';
// import '../../features/materials/domain/usecases/get_materials_usecase.dart';
// import '../../features/materials/domain/usecases/get_subjects_usecase.dart';
// import '../../features/materials/domain/usecases/upload_material_usecase.dart';
// import '../../features/materials/presentation/cubit/material_cubit.dart';

// // ✅ NEW: Grades

// final sl = GetIt.instance;

// Future<void> init() async {
//   // ===== Initialize Hive =====
//   await Hive.initFlutter();
//   Hive.registerAdapter(MaterialModelAdapter());
//   Hive.registerAdapter(SubjectModelAdapter());
//   Hive.registerAdapter(ClassModelAdapter());

//   final userBox = await Hive.openBox(HiveConstants.userBox);
//   final settingsBox = await Hive.openBox(HiveConstants.settingsBox);
//   final cacheBox = await Hive.openBox(HiveConstants.cacheBox);

//   sl.registerLazySingleton<Box<dynamic>>(
//     () => userBox,
//     instanceName: HiveConstants.userBox,
//   );
//   sl.registerLazySingleton<Box<dynamic>>(
//     () => settingsBox,
//     instanceName: HiveConstants.settingsBox,
//   );
//   sl.registerLazySingleton<Box<dynamic>>(
//     () => cacheBox,
//     instanceName: HiveConstants.cacheBox,
//   );

//   // ===== External =====
//   final sharedPreferences = await SharedPreferences.getInstance();
//   sl.registerLazySingleton(() => sharedPreferences);

//   // ===== Core =====
//   sl.registerLazySingleton<ApiClient>(() => ApiClient());

//   // ===== Features =====
//   _initAuth();
//   _initAttendance();
//   _initMaterial();
//   _initExams(); // ✅ NEW
//   _initGrades(); // ✅ NEW
//   _initNotifications(); // ✅ NEW
// }

// void _initAuth() {
//   sl.registerLazySingleton<AuthLocalDataSource>(
//     () => AuthLocalDataSourceImpl(
//       sl<Box<dynamic>>(instanceName: HiveConstants.userBox),
//     ),
//   );
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
//   );
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(
//       remoteDataSource: sl<AuthRemoteDataSource>(),
//       localDataSource: sl<AuthLocalDataSource>(),
//       apiClient: sl<ApiClient>(),
//     ),
//   );
//   sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
//   sl.registerFactory(
//     () => AuthCubit(
//       loginUseCase: sl<LoginUseCase>(),
//       authRepository: sl<AuthRepository>(),
//     ),
//   );
// }

// void _initAttendance() {
//   sl.registerFactory(() => AttendanceCubit(sl<ApiClient>()));
// }

// void _initMaterial() {
//   sl.registerLazySingleton<MaterialLocalDataSource>(
//     () => MaterialLocalDataSourceImpl(
//       sl<Box<dynamic>>(instanceName: HiveConstants.cacheBox),
//     ),
//   );
//   sl.registerLazySingleton<MaterialRemoteDataSource>(
//     () => MaterialRemoteDataSourceImpl(sl<ApiClient>()),
//   );
//   sl.registerLazySingleton<MaterialRepository>(
//     () => MaterialRepositoryImpl(
//       remoteDataSource: sl<MaterialRemoteDataSource>(),
//       localDataSource: sl<MaterialLocalDataSource>(),
//     ),
//   );
//   sl.registerLazySingleton(() => GetMaterialsUseCase(sl<MaterialRepository>()));
//   sl.registerLazySingleton(() => GetSubjectsUseCase(sl<MaterialRepository>()));
//   sl.registerLazySingleton(() => GetClassesUseCase(sl<MaterialRepository>()));
//   sl.registerLazySingleton(
//       () => UploadMaterialUseCase(sl<MaterialRepository>()));
//   sl.registerLazySingleton(
//       () => DeleteMaterialUseCase(sl<MaterialRepository>()));
//   sl.registerFactory(
//     () => MaterialCubit(
//       getMaterialsUseCase: sl<GetMaterialsUseCase>(),
//       getSubjectsUseCase: sl<GetSubjectsUseCase>(),
//       uploadMaterialUseCase: sl<UploadMaterialUseCase>(),
//       deleteMaterialUseCase: sl<DeleteMaterialUseCase>(),
//       getClassesUseCase: sl<GetClassesUseCase>(),
//     ),
//   );
// }

// // ✅ NEW
// void _initExams() {
//   sl.registerLazySingleton<ExamRepository>(
//     () => ExamRepositoryImpl(apiClient: sl<ApiClient>()),
//   );
//   sl.registerFactory(
//     () => ExamCubit(examRepository: sl<ExamRepository>()),
//   );
// }

// // // ✅ NEW
// void _initGrades() {
//   sl.registerLazySingleton<GradeRepository>(
//     () => GradeRepositoryImpl(apiClient: sl<ApiClient>()),
//   );
//   sl.registerFactory(
//     () => GradeCubit(gradeRepository: sl<GradeRepository>()),
//   );
// }

// // }

// void _initNotifications() {
//   sl.registerFactory(
//     () => NotificationCubit(sl<ApiClient>()), // ← ApiClient بدل Box
//   );
// }
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_management_app/features/exams/data/repositry/exam_repository_impl.dart';
import 'package:teacher_management_app/features/exams/domain/repositry/exam_repositry.dart';
import 'package:teacher_management_app/features/exams/presentation/cubite/cubite.dart';
import 'package:teacher_management_app/features/grades/domain/grade_repository.dart';
import 'package:teacher_management_app/features/grades/presentation/grade_cubit.dart';

// Models/Adapters
import 'package:teacher_management_app/features/materials/data/models/material_model.dart';
import 'package:teacher_management_app/features/materials/data/models/subject_model.dart';
import 'package:teacher_management_app/features/notfication/presentation/notification_cubit.dart';

// ✅ Chat
import 'package:teacher_management_app/features/chat/presentation/chat_cubit.dart';

// Core
import '../network/api_client.dart';
import '../constants/hive_constants.dart';

// Auth
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Attendance
import '../../features/attendance/presentation/cubit/attendance_cubit.dart';

// Materials
import '../../features/materials/data/datasources/material_local_datasource.dart';
import '../../features/materials/data/datasources/material_remote_datasource.dart';
import '../../features/materials/data/models/class_model.dart';
import '../../features/materials/data/repositories/material_repository_impl.dart';
import '../../features/materials/domain/repositories/material_repository.dart';
import '../../features/materials/domain/usecases/delete_material_usecase.dart';
import '../../features/materials/domain/usecases/get_classes_usecase.dart';
import '../../features/materials/domain/usecases/get_materials_usecase.dart';
import '../../features/materials/domain/usecases/get_subjects_usecase.dart';
import '../../features/materials/domain/usecases/upload_material_usecase.dart';
import '../../features/materials/presentation/cubit/material_cubit.dart';

// Grades

final sl = GetIt.instance;

Future<void> init() async {
  // ===== Initialize Hive =====
  await Hive.initFlutter();
  Hive.registerAdapter(MaterialModelAdapter());
  Hive.registerAdapter(SubjectModelAdapter());
  Hive.registerAdapter(ClassModelAdapter());

  final userBox = await Hive.openBox(HiveConstants.userBox);
  final settingsBox = await Hive.openBox(HiveConstants.settingsBox);
  final cacheBox = await Hive.openBox(HiveConstants.cacheBox);

  sl.registerLazySingleton<Box<dynamic>>(
    () => userBox,
    instanceName: HiveConstants.userBox,
  );
  sl.registerLazySingleton<Box<dynamic>>(
    () => settingsBox,
    instanceName: HiveConstants.settingsBox,
  );
  sl.registerLazySingleton<Box<dynamic>>(
    () => cacheBox,
    instanceName: HiveConstants.cacheBox,
  );

  // ===== External =====
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ===== Core =====
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ===== Features =====
  _initAuth();
  _initAttendance();
  _initMaterial();
  _initExams();
  _initGrades();
  _initNotifications();
  _initChat(); // ✅ NEW
}

void _initAuth() {
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sl<Box<dynamic>>(instanceName: HiveConstants.userBox),
    ),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      apiClient: sl<ApiClient>(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl<LoginUseCase>(),
      authRepository: sl<AuthRepository>(),
    ),
  );
}

void _initAttendance() {
  sl.registerFactory(() => AttendanceCubit(sl<ApiClient>()));
}

void _initMaterial() {
  sl.registerLazySingleton<MaterialLocalDataSource>(
    () => MaterialLocalDataSourceImpl(
      sl<Box<dynamic>>(instanceName: HiveConstants.cacheBox),
    ),
  );
  sl.registerLazySingleton<MaterialRemoteDataSource>(
    () => MaterialRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<MaterialRepository>(
    () => MaterialRepositoryImpl(
      remoteDataSource: sl<MaterialRemoteDataSource>(),
      localDataSource: sl<MaterialLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton(() => GetMaterialsUseCase(sl<MaterialRepository>()));
  sl.registerLazySingleton(() => GetSubjectsUseCase(sl<MaterialRepository>()));
  sl.registerLazySingleton(() => GetClassesUseCase(sl<MaterialRepository>()));
  sl.registerLazySingleton(
      () => UploadMaterialUseCase(sl<MaterialRepository>()));
  sl.registerLazySingleton(
      () => DeleteMaterialUseCase(sl<MaterialRepository>()));
  sl.registerFactory(
    () => MaterialCubit(
      getMaterialsUseCase: sl<GetMaterialsUseCase>(),
      getSubjectsUseCase: sl<GetSubjectsUseCase>(),
      uploadMaterialUseCase: sl<UploadMaterialUseCase>(),
      deleteMaterialUseCase: sl<DeleteMaterialUseCase>(),
      getClassesUseCase: sl<GetClassesUseCase>(),
    ),
  );
}

void _initExams() {
  sl.registerLazySingleton<ExamRepository>(
    () => ExamRepositoryImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerFactory(
    () => ExamCubit(examRepository: sl<ExamRepository>()),
  );
}

void _initGrades() {
  sl.registerLazySingleton<GradeRepository>(
    () => GradeRepositoryImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerFactory(
    () => GradeCubit(gradeRepository: sl<GradeRepository>()),
  );
}

void _initNotifications() {
  sl.registerFactory(
    () => NotificationCubit(sl<ApiClient>()),
  );
}

// ✅ NEW - Chat
void _initChat() {
  sl.registerFactory(
    () => ChatCubit(apiClient: sl<ApiClient>()),
  );
}
