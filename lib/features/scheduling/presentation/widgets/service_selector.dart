import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/molecules/service_card.dart';
import '../../../catalog/domain/entities/service.dart';


class ServiceSelector extends StatelessWidget {
  final List<Service> services;
  final Service? selectedService;
  final ValueChanged<Service> onServiceSelected;

  const ServiceSelector({
    super.key,
    required this.services,
    required this.selectedService,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: services
          .map(
            (service) => ServiceCard(
              service: service,
              isSelected: selectedService?.id == service.id,
              onTap: () => onServiceSelected(service),
            ),
          )
          .toList(),
    );
  }
}
