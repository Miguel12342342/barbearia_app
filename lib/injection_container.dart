import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

// ── Scheduling ──────────────────────────────────────────────────────────────
import 'features/scheduling/data/datasources/i_appointment_datasource.dart';
import 'features/scheduling/data/datasources/firebase_appointment_datasource.dart';
import 'features/scheduling/data/models/appointment_model.dart';
import 'features/scheduling/data/repositories/appointment_repository_impl.dart';
import 'features/scheduling/domain/repositories/i_appointment_repository.dart';
import 'features/scheduling/domain/usecases/book_appointment.dart';
import 'features/scheduling/domain/usecases/cancel_appointment.dart';
import 'features/scheduling/domain/usecases/watch_appointments.dart';
import 'features/scheduling/presentation/bloc/booking_bloc.dart';
import 'features/scheduling/presentation/cubit/booking_form_cubit.dart';

// ── Barber ───────────────────────────────────────────────────────────────────
import 'features/barber/data/repositories/barber_repository_impl.dart';
import 'features/barber/domain/repositories/i_barber_repository.dart';
import 'features/barber/domain/usecases/get_barbers.dart';

// ── Catalog (Services) ───────────────────────────────────────────────────────
import 'features/catalog/data/repositories/service_repository_impl.dart';
import 'features/catalog/domain/repositories/i_service_repository.dart';
import 'features/catalog/domain/usecases/get_services.dart';
import 'features/catalog/presentation/cubit/catalog_cubit.dart';

// ── Loyalty ──────────────────────────────────────────────────────────────────
import 'features/loyalty/data/repositories/loyalty_repository_impl.dart';
import 'features/loyalty/domain/repositories/i_loyalty_repository.dart';
import 'features/loyalty/domain/usecases/get_loyalty_program.dart';
import 'features/loyalty/presentation/cubit/loyalty_cubit.dart';

// ── Profile ──────────────────────────────────────────────────────────────────
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/i_profile_repository.dart';
import 'features/profile/domain/usecases/get_client_profile.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';

// ── Locale ───────────────────────────────────────────────────────────────────
import 'core/locale/locale_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Scheduling ─────────────────────────────────────────────────────────────

  sl.registerFactory(
    () => BookingBloc(
      bookAppointment: sl(),
      cancelAppointment: sl(),
      watchAppointments: sl(),
    ),
  );

  sl.registerFactory(
    () => BookingFormCubit(
      getServices: sl(),
      getBarbers: sl(),
    ),
  );

  sl.registerLazySingleton(() => BookAppointment(sl()));
  sl.registerLazySingleton(() => CancelAppointment(sl()));
  sl.registerLazySingleton(() => WatchAppointments(sl()));

  sl.registerLazySingleton<IAppointmentRepository>(
    () => AppointmentRepositoryImpl(sl()),
  );

  bool isFirebaseRunning = false;
  try {
    Firebase.app();
    isFirebaseRunning = true;
  } catch (_) {}

  if (isFirebaseRunning) {
    sl.registerLazySingleton<IAppointmentDataSource>(
      () => FirebaseAppointmentDataSource(sl()),
    );
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  } else {
    sl.registerLazySingleton<IAppointmentDataSource>(
      () => MockAppointmentDataSource(),
    );
  }

  // ── Barber ─────────────────────────────────────────────────────────────────

  sl.registerLazySingleton(() => GetBarbers(sl()));
  sl.registerLazySingleton<IBarberRepository>(() => BarberRepositoryImpl());

  // ── Catalog ────────────────────────────────────────────────────────────────

  sl.registerFactory(() => CatalogCubit(sl()));
  sl.registerLazySingleton(() => GetServices(sl()));
  sl.registerLazySingleton<IServiceRepository>(() => ServiceRepositoryImpl());

  // ── Loyalty ────────────────────────────────────────────────────────────────

  sl.registerFactory(
    () => LoyaltyCubit(
      getLoyaltyProgram: sl(),
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetLoyaltyProgram(sl()));
  sl.registerLazySingleton<ILoyaltyRepository>(() => LoyaltyRepositoryImpl());

  // ── Profile ────────────────────────────────────────────────────────────────

  sl.registerFactory(
    () => ProfileCubit(getClientProfile: sl(), repository: sl()),
  );
  sl.registerLazySingleton(() => GetClientProfile(sl()));
  sl.registerLazySingleton<IProfileRepository>(() => ProfileRepositoryImpl());

  // ── Locale ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => LocaleCubit());
}

// ── Mock datasource for UI-only development (no Firebase) ────────────────────

class MockAppointmentDataSource implements IAppointmentDataSource {
  @override
  Stream<List<AppointmentModel>> watchAppointments(String userId) =>
      Stream.value([]);

  @override
  Future<void> bookAppointment(AppointmentModel model) =>
      Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> cancelAppointment(String appointmentId) =>
      Future.delayed(const Duration(milliseconds: 500));
}
