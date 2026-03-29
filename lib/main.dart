import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/locale/app_localizations.dart';
import 'core/locale/locale_cubit.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/catalog/presentation/cubit/catalog_cubit.dart';
import 'features/loyalty/presentation/cubit/loyalty_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not initialized (UI-only mode): $e');
  }

  await di.init();

  runApp(const CorteEBarbaApp());
}

class CorteEBarbaApp extends StatelessWidget {
  const CorteEBarbaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LocaleCubit>()),
        BlocProvider(create: (_) => di.sl<CatalogCubit>()..load()),
        BlocProvider(create: (_) => di.sl<LoyaltyCubit>()),
        BlocProvider(create: (_) => di.sl<ProfileCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) => MaterialApp.router(
          title: 'Corte & Barba',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
