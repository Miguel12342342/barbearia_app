import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/molecules/barber_card.dart';
import '../../../barber/domain/entities/barber.dart';


class BarberSelector extends StatelessWidget {
  final List<Barber> barbers;
  final Barber? selectedBarber;
  final ValueChanged<Barber> onBarberSelected;

  const BarberSelector({
    super.key,
    required this.barbers,
    required this.selectedBarber,
    required this.onBarberSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (barbers.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: barbers.length,
        itemBuilder: (context, index) {
          final barber = barbers[index];
          return BarberCard(
            barber: barber,
            isSelected: selectedBarber?.id == barber.id,
            onTap: () => onBarberSelected(barber),
          );
        },
      ),
    );
  }
}
