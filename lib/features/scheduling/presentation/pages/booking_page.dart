import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/presentation/widgets/organisms/brand_app_bar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/atoms/section_label.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/value_objects/appointment_date.dart';
import '../../domain/value_objects/appointment_status.dart';
import '../../../home/presentation/pages/shell_page.dart';
import '../../domain/value_objects/phone_number.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../cubit/booking_form_cubit.dart';
import '../cubit/booking_form_state.dart';
import '../widgets/service_selector.dart';
import '../widgets/barber_selector.dart';
import '../widgets/date_time_selector.dart';
import '../widgets/booking_summary_card.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BookingFormCubit>()..loadFormData()),
        BlocProvider(create: (_) => sl<BookingBloc>()),
      ],
      child: const _BookingView(),
    );
  }
}

class _BookingView extends StatelessWidget {
  const _BookingView();

  String _formattedDateTime(BuildContext context, DateTime date, String time) {
    final l10n = AppLocalizations.of(context);
    final formatted =
        DateFormat("EEEE, d 'de' MMM", l10n.dateLocale).format(date);
    return '$formatted às $time';
  }

  void _onConfirm(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formState = context.read<BookingFormCubit>().state;
    if (!formState.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillAllSteps),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final parts = formState.selectedTime!.split(':');
    final hour = int.tryParse(parts.elementAtOrNull(0) ?? '');
    final minute = int.tryParse(parts.elementAtOrNull(1) ?? '');
    if (hour == null || minute == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.invalidTime),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final appointmentDate = DateTime(
      formState.selectedDate!.year,
      formState.selectedDate!.month,
      formState.selectedDate!.day,
      hour,
      minute,
    );

    final appointment = Appointment(
      id: UniqueKey().toString(),
      userId: context.read<AuthCubit>().state.userId ?? '',
      serviceId: formState.selectedService!.id,
      barberId: formState.selectedBarber!.id,
      serviceName: formState.selectedService!.name,
      barberName: formState.selectedBarber!.name,
      date: AppointmentDate(appointmentDate),
      clientPhone: PhoneNumber(AppConstants.kDevPhone),
      status: AppointmentStatus.pending,
      isPremium: formState.selectedService!.isPremium,
    );

    context.read<BookingBloc>().add(BookAppointmentEvent(appointment));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BrandAppBar(
        onMenuTap: () => ShellPage.scaffoldKey.currentState?.openDrawer(),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.success) {
            final l10n = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.bookingConfirmed),
                backgroundColor: Colors.green,
              ),
            );
            context.read<BookingFormCubit>().reset();
          } else if (state.status == BookingStatus.failure) {
            final l10n = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${l10n.bookingError}${state.errorMessage}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<BookingFormCubit, BookingFormState>(
          builder: (context, formState) {
            return BlocBuilder<BookingBloc, BookingState>(
              builder: (context, bookingState) {
                final isSubmitting =
                    bookingState.status == BookingStatus.loading;

                final l10n = AppLocalizations.of(context);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.bookTitle,
                              style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                letterSpacing: -1.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.bookSubtitle,
                              style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      SectionLabel(step: l10n.step1Label, title: l10n.step1Title),
                      ServiceSelector(
                        services: formState.services,
                        selectedService: formState.selectedService,
                        onServiceSelected: (s) =>
                            context.read<BookingFormCubit>().selectService(s),
                      ),
                      const SizedBox(height: 48),
                      SectionLabel(step: l10n.step2Label, title: l10n.step2Title),
                      BarberSelector(
                        barbers: formState.barbers,
                        selectedBarber: formState.selectedBarber,
                        onBarberSelected: (b) =>
                            context.read<BookingFormCubit>().selectBarber(b),
                      ),
                      const SizedBox(height: 48),
                      SectionLabel(step: l10n.step3Label, title: l10n.step3Title),
                      DateTimeSelector(
                        selectedDate: formState.selectedDate,
                        selectedTime: formState.selectedTime,
                        onDateSelected: (date) =>
                            context.read<BookingFormCubit>().selectDate(date),
                        onTimeSelected: (time) =>
                            context.read<BookingFormCubit>().selectTime(time),
                        availableSlots: formState.availableSlots,
                        slotsStatus: formState.slotsStatus,
                      ),
                      const SizedBox(height: 40),
                      BookingSummaryCard(
                        serviceName: formState.selectedService?.name ?? '-',
                        servicePrice:
                            formState.selectedService?.formattedPrice ?? '-',
                        barberName: formState.selectedBarber?.name ?? '-',
                        dateAndTime: formState.selectedDate != null &&
                                formState.selectedTime != null
                            ? _formattedDateTime(
                                context,
                                formState.selectedDate!,
                                formState.selectedTime!,
                              )
                            : '-',
                        isLoading: isSubmitting,
                        onConfirm: () => _onConfirm(context),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
