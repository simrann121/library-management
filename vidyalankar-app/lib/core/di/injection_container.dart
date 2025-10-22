// Dependency Injection Container for Vidyalankar Library Management System

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/biometric_auth_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// College Selection
import '../../features/college_selection/data/repositories/college_selection_repository_impl.dart';
import '../../features/college_selection/domain/repositories/college_selection_repository.dart';
import '../../features/college_selection/domain/usecases/get_colleges_usecase.dart';
import '../../features/college_selection/domain/usecases/select_college_usecase.dart';
import '../../features/college_selection/presentation/bloc/college_selection_bloc.dart';

// Library
import '../../features/library/data/repositories/library_repository_impl.dart';
import '../../features/library/domain/repositories/library_repository.dart';
import '../../features/library/domain/usecases/get_library_status_usecase.dart';
import '../../features/library/presentation/bloc/library_bloc.dart';

// Books
import '../../features/books/data/repositories/books_repository_impl.dart';
import '../../features/books/domain/repositories/books_repository.dart';
import '../../features/books/domain/usecases/search_books_usecase.dart';
import '../../features/books/presentation/bloc/books_bloc.dart';

// Profile
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

// Settings
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings_usecase.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';

// Admin
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/usecases/get_trust_overview_usecase.dart';
import '../../features/admin/presentation/bloc/admin_bloc.dart';

// Analytics
import '../../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../../features/analytics/domain/repositories/analytics_repository.dart';
import '../../features/analytics/domain/usecases/get_analytics_data_usecase.dart';
import '../../features/analytics/presentation/bloc/analytics_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Auth
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUsecase(sl()));
  sl.registerLazySingleton(() => BiometricAuthUsecase(sl()));
  sl.registerFactory(() => AuthBloc(
        loginUsecase: sl(),
        logoutUsecase: sl(),
        checkAuthStatusUsecase: sl(),
        biometricAuthUsecase: sl(),
      ));

  // College Selection
  sl.registerLazySingleton<CollegeSelectionRepository>(
      () => CollegeSelectionRepositoryImpl());
  sl.registerLazySingleton(() => GetCollegesUsecase(sl()));
  sl.registerLazySingleton(() => SelectCollegeUsecase(sl()));
  sl.registerFactory(() => CollegeSelectionBloc());

  // Library
  sl.registerLazySingleton<LibraryRepository>(() => LibraryRepositoryImpl());
  sl.registerLazySingleton(() => GetLibraryStatusUsecase(sl()));
  sl.registerFactory(() => LibraryBloc(
        getLibraryStatusUsecase: sl(),
      ));

  // Books
  sl.registerLazySingleton<BooksRepository>(() => BooksRepositoryImpl());
  sl.registerLazySingleton(() => SearchBooksUsecase(sl()));
  sl.registerFactory(() => BooksBloc(
        searchBooksUsecase: sl(),
      ));

  // Profile
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  sl.registerLazySingleton(() => GetProfileUsecase(sl()));
  sl.registerFactory(() => ProfileBloc(
        getProfileUsecase: sl(),
      ));

  // Settings
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl());
  sl.registerLazySingleton(() => GetSettingsUsecase(sl()));
  sl.registerFactory(() => SettingsBloc(
        getSettingsUsecase: sl(),
      ));

  // Admin
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl());
  sl.registerLazySingleton(() => GetTrustOverviewUsecase(sl()));
  sl.registerFactory(() => AdminBloc(
        getTrustOverviewUsecase: sl(),
      ));

  // Analytics
  sl.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl());
  sl.registerLazySingleton(() => GetAnalyticsDataUsecase(sl()));
  sl.registerFactory(() => AnalyticsBloc(
        getAnalyticsDataUsecase: sl(),
      ));
}
