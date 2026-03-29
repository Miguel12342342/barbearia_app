import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../barber/domain/entities/barber.dart';
import '../../../barber/domain/usecases/get_barbers.dart';
import '../../../catalog/domain/entities/service.dart';
import '../../../catalog/domain/usecases/get_services.dart';
import 'booking_form_state.dart';

class BookingFormCubit extends Cubit<BookingFormState> {
  final GetServices _getServices;
  final GetBarbers _getBarbers;

  BookingFormCubit({
    required GetServices getServices,
    required GetBarbers getBarbers,
  })  : _getServices = getServices,
        _getBarbers = getBarbers,
        super(const BookingFormState());

  Future<void> loadFormData() async {
    emit(state.copyWith(status: BookingFormStatus.loadingData));

    final servicesResult = await _getServices(NoParams());
    final barbersResult = await _getBarbers(NoParams());

    servicesResult.fold(
      (failure) => emit(state.copyWith(
        status: BookingFormStatus.error,
        errorMessage: failure.message,
      )),
      (services) {
        barbersResult.fold(
          (failure) => emit(state.copyWith(
            status: BookingFormStatus.error,
            errorMessage: failure.message,
          )),
          (barbers) => emit(state.copyWith(
            status: BookingFormStatus.ready,
            services: services,
            barbers: barbers,
          )),
        );
      },
    );
  }

  void selectService(Service service) =>
      emit(state.copyWith(selectedService: service));

  void selectBarber(Barber barber) =>
      emit(state.copyWith(selectedBarber: barber));

  void selectDate(DateTime date) =>
      emit(state.copyWith(selectedDate: date, clearSelectedTime: true));

  void selectTime(String time) => emit(state.copyWith(selectedTime: time));

  void reset() => emit(const BookingFormState());
}
