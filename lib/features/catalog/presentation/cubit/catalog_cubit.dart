import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_services.dart';
import 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final GetServices _getServices;

  CatalogCubit(this._getServices) : super(const CatalogState());

  Future<void> load() async {
    if (state.status == CatalogStatus.loaded) return;
    emit(state.copyWith(status: CatalogStatus.loading));
    final result = await _getServices(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: CatalogStatus.error,
        errorMessage: failure.message,
      )),
      (services) => emit(state.copyWith(
        status: CatalogStatus.loaded,
        services: services,
      )),
    );
  }
}
