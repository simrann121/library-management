// Vidyalankar Library Management System - Flutter App
// Main entry point for the multi-college library management app

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/offline_storage_service.dart';
import 'core/services/sync_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/push_notification_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/college_selection/presentation/bloc/college_selection_bloc.dart';
import 'features/library/presentation/bloc/library_bloc.dart';
import 'features/admin/presentation/bloc/admin_bloc.dart';
import 'features/analytics/presentation/bloc/analytics_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize offline services
  await OfflineStorageService.initialize();
  SyncService.initialize(
      baseUrl: 'https://api.vidyalankar.edu'); // Replace with actual API URL
  await ConnectivityService().initialize();
  await PushNotificationService().initialize();

  // Initialize dependency injection
  await di.init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const VidyalankarLibraryApp());
}

class VidyalankarLibraryApp extends StatelessWidget {
  const VidyalankarLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<CollegeSelectionBloc>(
          create: (context) => di.sl<CollegeSelectionBloc>(),
        ),
        BlocProvider<LibraryBloc>(create: (context) => di.sl<LibraryBloc>()),
        BlocProvider<AdminBloc>(create: (context) => di.sl<AdminBloc>()),
        BlocProvider<AnalyticsBloc>(
            create: (context) => di.sl<AnalyticsBloc>()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0), // Prevent text scaling
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
