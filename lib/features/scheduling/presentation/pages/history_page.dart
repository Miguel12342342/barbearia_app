import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/presentation/widgets/atoms/status_pill.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/value_objects/appointment_status.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  PillVariant _pillVariant(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return PillVariant.confirmed;
      case AppointmentStatus.canceled:
        return PillVariant.canceled;
      case AppointmentStatus.pending:
        return PillVariant.pending;
    }
  }

  String _statusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'CONFIRMADO';
      case AppointmentStatus.canceled:
        return 'CANCELADO';
      case AppointmentStatus.pending:
        return 'PENDENTE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        title: const Text(
          'Histórico',
          style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(color: AppColors.textLight),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state.status == BookingStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            );
          }

          final sorted = [...state.appointments]..sort((a, b) {
              final da = a.date.value.fold((_) => DateTime(0), (d) => d);
              final db = b.date.value.fold((_) => DateTime(0), (d) => d);
              return db.compareTo(da);
            });

          if (sorted.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum agendamento encontrado.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            );
          }

          final formatter = DateFormat("d 'de' MMM yyyy, HH:mm", 'pt_BR');

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: sorted.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white10, height: 1),
            itemBuilder: (context, index) {
              final apt = sorted[index];
              final aptDate =
                  apt.date.value.fold((_) => DateTime(0), (d) => d);
              final formattedDate = formatter.format(aptDate);

              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.content_cut_rounded,
                    color: AppColors.primaryGold,
                    size: 20,
                  ),
                ),
                title: Text(
                  apt.serviceName,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      apt.barberName,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
                trailing: StatusPill(
                  label: _statusLabel(apt.status),
                  variant: _pillVariant(apt.status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
