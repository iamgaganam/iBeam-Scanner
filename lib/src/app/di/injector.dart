import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ibeacon_wrapper/ibeacon_wrapper.dart';

import '../../core/services/local_notification_service.dart';
import '../../features/alerts/data/datasources/alerts_local_data_source.dart';
import '../../features/alerts/data/repositories/alerts_repository_impl.dart';
import '../../features/alerts/domain/repositories/alerts_repository.dart';
import '../../features/alerts/domain/usecases/get_alerts.dart';
import '../../features/alerts/presentation/bloc/alerts_bloc.dart';
import '../../features/auth/data/datasources/firebase_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/observe_auth_state.dart';
import '../../features/auth/domain/usecases/sign_in_with_apple.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/beacon_scanner/data/datasources/ibeacon_data_source.dart';
import '../../features/beacon_scanner/data/repositories/beacon_repository_impl.dart';
import '../../features/beacon_scanner/domain/repositories/beacon_repository.dart';
import '../../features/beacon_scanner/domain/usecases/initialize_scanner.dart';
import '../../features/beacon_scanner/domain/usecases/observe_beacons.dart';
import '../../features/beacon_scanner/domain/usecases/observe_scanner_status.dart';
import '../../features/beacon_scanner/domain/usecases/start_scanning.dart';
import '../../features/beacon_scanner/domain/usecases/stop_scanning.dart';
import '../../features/beacon_scanner/presentation/bloc/beacon_scanner_bloc.dart';
import '../../features/permissions/data/datasources/device_permission_data_source.dart';
import '../../features/permissions/data/repositories/permission_repository_impl.dart';
import '../../features/permissions/domain/repositories/permission_repository.dart';
import '../../features/permissions/domain/usecases/get_permission_status.dart';
import '../../features/permissions/domain/usecases/request_permissions.dart';
import '../../features/permissions/presentation/bloc/permission_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<AuthBloc>()) {
    return;
  }

  final LocalNotificationService notificationService =
      LocalNotificationService();
  await notificationService.initialize();
  sl.registerSingleton<LocalNotificationService>(notificationService);

  sl.registerLazySingleton<IBeaconScanner>(() {
    final bool isApplePlatform =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    final bool isAndroidPlatform =
        defaultTargetPlatform == TargetPlatform.android;

    if (!kIsWeb && (isAndroidPlatform || isApplePlatform)) {
      return FailoverIBeaconScanner(
        primary: FlutterBlueIBeaconScanner(),
        fallback: MockIBeaconScanner(),
      );
    }
    return MockIBeaconScanner();
  });

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  await googleSignIn.initialize();

  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(
      firebaseAuth: FirebaseAuth.instance,
      googleSignIn: googleSignIn,
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<ObserveAuthState>(() => ObserveAuthState(sl()));
  sl.registerLazySingleton<SignInWithGoogle>(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton<SignInWithApple>(() => SignInWithApple(sl()));
  sl.registerLazySingleton<SignOut>(() => SignOut(sl()));

  sl.registerLazySingleton<DevicePermissionDataSource>(
    DevicePermissionDataSource.new,
  );
  sl.registerLazySingleton<PermissionRepository>(
    () => PermissionRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<GetPermissionStatus>(
    () => GetPermissionStatus(sl()),
  );
  sl.registerLazySingleton<RequestPermissions>(() => RequestPermissions(sl()));

  sl.registerLazySingleton<AlertsLocalDataSource>(AlertsLocalDataSource.new);
  sl.registerLazySingleton<AlertsRepository>(
    () => AlertsRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<GetAlerts>(() => GetAlerts(sl()));

  sl.registerLazySingleton<IBeaconDataSource>(
    () => IBeaconDataSource(scanner: sl()),
  );
  sl.registerLazySingleton<BeaconRepository>(
    () => BeaconRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<InitializeScanner>(() => InitializeScanner(sl()));
  sl.registerLazySingleton<ObserveBeacons>(() => ObserveBeacons(sl()));
  sl.registerLazySingleton<ObserveScannerStatus>(
    () => ObserveScannerStatus(sl()),
  );
  sl.registerLazySingleton<StartScanning>(() => StartScanning(sl()));
  sl.registerLazySingleton<StopScanning>(() => StopScanning(sl()));

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      observeAuthState: sl(),
      signInWithGoogle: sl(),
      signInWithApple: sl(),
      signOut: sl(),
    ),
  );
  sl.registerFactory<PermissionBloc>(
    () => PermissionBloc(getPermissionStatus: sl(), requestPermissions: sl()),
  );
  sl.registerFactory<AlertsBloc>(() => AlertsBloc(getAlerts: sl()));
  sl.registerFactory<BeaconScannerBloc>(
    () => BeaconScannerBloc(
      initializeScanner: sl(),
      observeBeacons: sl(),
      observeScannerStatus: sl(),
      startScanning: sl(),
      stopScanning: sl(),
      notificationService: sl(),
    ),
  );
}
