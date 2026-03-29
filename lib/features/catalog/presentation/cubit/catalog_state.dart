import 'package:equatable/equatable.dart';
import '../../domain/entities/service.dart';

enum CatalogStatus { initial, loading, loaded, error }

class CatalogState extends Equatable {
  final CatalogStatus status;
  final List<Service> services;
  final String errorMessage;

  const CatalogState({
    this.status = CatalogStatus.initial,
    this.services = const [],
    this.errorMessage = '',
  });

  CatalogState copyWith({
    CatalogStatus? status,
    List<Service>? services,
    String? errorMessage,
  }) {
    return CatalogState(
      status: status ?? this.status,
      services: services ?? this.services,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, services, errorMessage];
}
