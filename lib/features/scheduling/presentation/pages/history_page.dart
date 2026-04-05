import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/presentation/widgets/atoms/gold_primary_button.dart';
import '../../../../core/presentation/widgets/atoms/status_pill.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/usecases/get_available_slots.dart';
import '../../domain/value_objects/appointment_status.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../cubit/booking_form_state.dart';
import '../widgets/date_time_selector.dart';

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

  void _showRescheduleSheet(BuildContext context, Appointment apt) {
    final bloc = context.read<BookingBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _RescheduleSheet(
        appointment: apt,
        onReschedule: (newDateTime) {
          bloc.add(RescheduleAppointmentEvent(apt.id, newDateTime));
        },
      ),
    );
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
          style: TextStyle(
              color: AppColors.textLight, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(color: AppColors.textLight),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state.status == BookingStatus.loading) {
            return const Center(
              child:
                  CircularProgressIndicator(color: AppColors.primaryGold),
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

          final formatter =
              DateFormat("d 'de' MMM yyyy, HH:mm", 'pt_BR');
          final now = DateTime.now();

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
              final isUpcoming = aptDate.isAfter(now);
              final isPast = !isUpcoming;
              final canReschedule =
                  isUpcoming && apt.status != AppointmentStatus.canceled;
              final canRate = isPast &&
                  apt.status == AppointmentStatus.confirmed;

              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        AppColors.primaryGold.withValues(alpha: 0.1),
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
                    if (canReschedule)
                      TextButton.icon(
                        icon: const Icon(Icons.edit_calendar_rounded,
                            size: 16, color: AppColors.primaryGold),
                        label: const Text(
                          'Remarcar',
                          style: TextStyle(
                              color: AppColors.primaryGold, fontSize: 12),
                        ),
                        onPressed: () =>
                            _showRescheduleSheet(context, apt),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    if (canRate)
                      _StarRating(
                        appointmentId: apt.id,
                        currentRating: apt.rating,
                        onRate: (score) => context
                            .read<BookingBloc>()
                            .add(RateAppointmentEvent(apt.id, score)),
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

class _StarRating extends StatelessWidget {
  final String appointmentId;
  final int? currentRating;
  final void Function(int) onRate;

  const _StarRating({
    required this.appointmentId,
    required this.currentRating,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: List.generate(5, (i) {
          final filled = currentRating != null && i < currentRating!;
          return GestureDetector(
            onTap: currentRating == null ? () => onRate(i + 1) : null,
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                filled
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: filled
                    ? AppColors.primaryGold
                    : AppColors.textMuted,
                size: 18,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _RescheduleSheet extends StatefulWidget {
  final Appointment appointment;
  final void Function(DateTime) onReschedule;
  const _RescheduleSheet(
      {required this.appointment, required this.onReschedule});

  @override
  State<_RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends State<_RescheduleSheet> {
  DateTime? _selectedDate;
  String? _selectedTime;
  List<String> _slots = const [];
  BookingFormSlotsStatus _slotsStatus = BookingFormSlotsStatus.idle;

  late final GetAvailableSlots _getAvailableSlots = sl<GetAvailableSlots>();

  Future<void> _fetchSlots(DateTime date) async {
    setState(() {
      _slotsStatus = BookingFormSlotsStatus.loading;
      _selectedTime = null;
    });
    final result = await _getAvailableSlots(GetAvailableSlotsParams(
      barberId: widget.appointment.barberId,
      date: date,
      durationMinutes: 30,
    ));
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _slots = const [];
        _slotsStatus = BookingFormSlotsStatus.error;
      }),
      (slots) => setState(() {
        _slots = slots;
        _slotsStatus = BookingFormSlotsStatus.loaded;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Remarcar Agendamento',
                style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            DateTimeSelector(
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
              availableSlots: _slots,
              slotsStatus: _slotsStatus,
              onDateSelected: (date) {
                setState(() => _selectedDate = date);
                _fetchSlots(date);
              },
              onTimeSelected: (time) =>
                  setState(() => _selectedTime = time),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GoldPrimaryButton(
                label: 'CONFIRMAR REMARQUE',
                onPressed: _selectedDate != null && _selectedTime != null
                    ? () {
                        final parts = _selectedTime!.split(':');
                        final newDateTime = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                          int.parse(parts[0]),
                          int.parse(parts[1]),
                        );
                        Navigator.pop(context);
                        widget.onReschedule(newDateTime);
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
