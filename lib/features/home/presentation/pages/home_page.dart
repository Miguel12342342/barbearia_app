import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/home_header.dart';
import '../widgets/upcoming_appointment_card.dart';
import '../widgets/loyalty_status_card.dart';
import '../widgets/curated_services_list.dart';
import 'shell_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // TODO: replace with real data from BookingBloc
  static const _mockServiceName = 'Artisanal Fade & Trim';
  static const _mockBarberName = 'Master Barber Julian';
  static const _mockTime = '18:30';
  static const _mockDate = 'Hoje, 24 de Out';
  static const _mockCuts = 9;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final displayName = authState.displayName
            ?.split(' ')
            .first ??
        authState.email?.split('@').first ??
        'Você';
    final photoUrl = null; // TODO: from ProfileCubit when photo upload is implemented

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.primaryGold),
          onPressed: () => ShellPage.scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Corte & Barba',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => context.go('/profile'),
              child: Semantics(
                label: 'Foto de perfil de $displayName',
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.cardBackground,
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? const Icon(
                          Icons.person_rounded,
                          color: AppColors.textMuted,
                          size: 20,
                        )
                      : null,
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
            const UpcomingAppointmentCard(
              serviceName: _mockServiceName,
              barberName: _mockBarberName,
              timeLabel: _mockTime,
              dateLabel: _mockDate,
            ),
            const LoyaltyStatusCard(cutsCount: _mockCuts),
            const CuratedServicesList(),
          ],
        ),
      ),
    );
  }
}
