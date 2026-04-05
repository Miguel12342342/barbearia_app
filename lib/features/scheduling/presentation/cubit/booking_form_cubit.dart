import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../barber/domain/entities/barber.dart';
import '../../../barber/domain/usecases/get_barbers.dart';
import '../../../catalog/domain/entities/service.dart';
import '../../../catalog/domain/usecases/get_services.dart';
import '../../domain/usecases/get_available_slots.dart';
import 'booking_form_state.dart';

class BookingFormCubit extends Cubit<BookingFormState> {
  final GetServices _getServices;
  final GetBarbers _getBarbers;
  final GetAvailableSlots _getAvailableSlots;

  Object _fetchToken = Object();

  BookingFormCubit({
    required GetServices getServices,
    required GetBarbers getBarbers,
    required GetAvailableSlots getAvailableSlots,
  })  : _getServices = getServices,
        _getBarbers = getBarbers,
        _getAvailableSlots = getAvailableSlots,
        super(const BookingFormState());

  Future<void> loadFormData() async {
    if (isClosed) return;
    emit(state.copyWith(status: BookingFormStatus.loadingData));

    final servicesResult = await _getServices(NoParams());
    final barbersResult = await _getBarbers(NoParams());

    if (isClosed) return;

    servicesResult.fold(
      (failure) => emit(state.copyWith(
        status: BookingFormStatus.error,
        errorMessage: failure.message,
      )),
      (services) {
        if (isClosed) return;
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

  void selectService(Service service) {
    if (!isClosed) {
      emit(state.copyWith(selectedService: service));
      if (state.selectedBarber != null && state.selectedDate != null) {
        _fetchSlots();
      }
    }
  }

  void selectBarber(Barber barber) {
    if (!isClosed) {
      emit(state.copyWith(selectedBarber: barber));
      _fetchSlots();
    }
  }

  void selectDate(DateTime date) {
    if (!isClosed) {
      emit(state.copyWith(selectedDate: date, clearSelectedTime: true));
      _fetchSlots();
    }
  }

  void selectTime(String time) {
    if (!isClosed) emit(state.copyWith(selectedTime: time));
  }

  void reset() {
    if (!isClosed) emit(const BookingFormState());
  }

  Future<void> _fetchSlots() async {
    final barber = state.selectedBarber;
    final date = state.selectedDate;
    if (barber == null || date == null) return;
    final token = _fetchToken = Object();
    emit(state.copyWith(slotsStatus: BookingFormSlotsStatus.loading));
    final result = await _getAvailableSlots(
      GetAvailableSlotsParams(
        barberId: barber.id,
        date: date,
        durationMinutes: state.selectedService?.durationMinutes ?? 30,
      ),
    );
    if (token != _fetchToken || isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(
        slotsStatus: BookingFormSlotsStatus.error,
        errorMessage: failure.message,
      )),
      (slots) => emit(state.copyWith(
        slotsStatus: BookingFormSlotsStatus.loaded,
        availableSlots: slots,
      )),
    );
  }
}
