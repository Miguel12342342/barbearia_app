import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/presentation/widgets/organisms/brand_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../loyalty/presentation/cubit/loyalty_cubit.dart';
import '../../../loyalty/presentation/cubit/loyalty_state.dart';
import '../../../scheduling/domain/value_objects/appointment_status.dart';
import '../../../scheduling/presentation/bloc/booking_bloc.dart';
import '../../../scheduling/presentation/bloc/booking_state.dart';
import '../widgets/home_header.dart';
import '../widgets/upcoming_appointment_card.dart';
import '../widgets/loyalty_status_card.dart';
import '../widgets/curated_services_list.dart';
import 'shell_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final displayName = authState.displayName?.split(' ').first ??
        authState.email?.split('@').first ??
        'Você';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BrandAppBar(
        onMenuTap: () => ShellPage.scaffoldKey.currentState?.openDrawer(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => context.go('/profile'),
              child: Semantics(
                label: 'Foto de perfil de $displayName',
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.cardBackground,
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(userName: displayName),
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, bookingState) {
                final now = DateTime.now();
                final upcoming = bookingState.appointments
                    .where((a) =>
                        a.status != AppointmentStatus.canceled &&
                        a.date.value.fold((_) => false, (d) => d.isAfter(now)))
                    .toList()
                  ..sort((a, b) {
                    final da =
                        a.date.value.fold((_) => DateTime(9999), (d) => d);
                    final db =
                        b.date.value.fold((_) => DateTime(9999), (d) => d);
                    return da.compareTo(db);
                  });

                if (upcoming.isEmpty) {
                  return const UpcomingAppointmentCard();
                }

                final apt = upcoming.first;
                final aptDate =
                    apt.date.value.fold((_) => DateTime.now(), (d) => d);
                final timeLabel = DateFormat('HH:mm').format(aptDate);
                final dateLabel =
                    DateFormat("d 'de' MMM", 'pt_BR').format(aptDate);

                return UpcomingAppointmentCard(
                  serviceName: apt.serviceName,
                  barberName: apt.barberName,
                  timeLabel: timeLabel,
                  dateLabel: dateLabel,
                );
              },
            ),
            BlocBuilder<LoyaltyCubit, LoyaltyState>(
              builder: (context, loyaltyState) {
                final cuts = loyaltyState.program?.currentCuts ?? 0;
                return LoyaltyStatusCard(cutsCount: cuts);
              },
            ),
            const CuratedServicesList(),
          ],
        ),
      ),
    );
  }
}
