import 'package:flutter/material.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/molecules/day_pill.dart';
import '../../../../core/presentation/widgets/molecules/time_slot_button.dart';
import '../cubit/booking_form_state.dart';

class DateTimeSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final String? selectedTime;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String> onTimeSelected;
  final List<String> availableSlots;
  final BookingFormSlotsStatus slotsStatus;

  const DateTimeSelector({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.availableSlots,
    required this.slotsStatus,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.add(Duration(days: i)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.selectDay,
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = selectedDate != null &&
                  selectedDate!.day == day.day &&
                  selectedDate!.month == day.month;
              return DayPill(
                date: day,
                isSelected: isSelected,
                onTap: () => onDateSelected(day),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.availableSlots,
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSlotsContent(l10n),
        ),
      ],
    );
  }

  Widget _buildSlotsContent(AppLocalizations l10n) {
    if (slotsStatus == BookingFormSlotsStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(color: AppColors.primaryGold),
        ),
      );
    }
    if (slotsStatus == BookingFormSlotsStatus.error) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          l10n.slotsError,
          style: const TextStyle(color: AppColors.error),
        ),
      );
    }
    if (slotsStatus == BookingFormSlotsStatus.loaded && availableSlots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          l10n.noSlotsAvailable,
          style: const TextStyle(color: AppColors.textMuted),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 24) / 3;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: availableSlots
              .map(
                (time) => SizedBox(
                  width: itemWidth,
                  child: TimeSlotButton(
                    time: time,
                    isSelected: selectedTime == time,
                    onTap: () => onTimeSelected(time),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
