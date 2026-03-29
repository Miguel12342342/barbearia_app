import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/upcoming_appointment_card.dart';
import '../widgets/loyalty_status_card.dart';
import '../widgets/curated_services_list.dart';
import 'shell_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // TODO: replace with real data from BookingBloc + AuthCubit
  static const _mockServiceName = 'Artisanal Fade & Trim';
  static const _mockBarberName = 'Master Barber Julian';
  static const _mockTime = '18:30';
  static const _mockDate = 'Hoje, 24 de Out';
  static const _mockUserName = 'Arthur';
  static const _mockCuts = 9;
  // TODO: replace with real user photo URL from auth/profile
  static const String? _mockPhotoUrl = null;

  @override
  Widget build(BuildContext context) {
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
                label: 'Foto de perfil de $_mockUserName',
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.cardBackground,
                  backgroundImage: _mockPhotoUrl != null
                      ? NetworkImage(_mockPhotoUrl!)
                      : null,
                  child: _mockPhotoUrl == null
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
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(userName: _mockUserName),
            UpcomingAppointmentCard(
              serviceName: _mockServiceName,
              barberName: _mockBarberName,
              timeLabel: _mockTime,
              dateLabel: _mockDate,
            ),
            LoyaltyStatusCard(cutsCount: _mockCuts),
            CuratedServicesList(),
          ],
        ),
      ),
    );
  }
}
