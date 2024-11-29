import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:monscolis/features/appointments/data/appointments_repository.dart';
import 'package:monscolis/features/stores/data/stores_repository.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class CancelAppointment extends HomeEvent {
  final String appointmentId;

  const CancelAppointment(this.appointmentId);

  @override
  List<Object> get props => [appointmentId];
}

// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> stores;
  final Map<String, dynamic>? nextAppointment;

  const HomeLoaded({
    required this.stores,
    this.nextAppointment,
  });

  @override
  List<Object?> get props => [stores, nextAppointment];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StoresRepository _storesRepository;
  final AppointmentsRepository _appointmentsRepository;

  HomeBloc({
    StoresRepository? storesRepository,
    AppointmentsRepository? appointmentsRepository,
  })  : _storesRepository = storesRepository ?? StoresRepository(),
        _appointmentsRepository = appointmentsRepository ?? AppointmentsRepository(),
        super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<CancelAppointment>(_onCancelAppointment);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoading());

      // Load stores and upcoming appointments in parallel
      final results = await Future.wait([
        _storesRepository.getStores(),
        _appointmentsRepository.getAppointments(
          status: 'scheduled',
          fromDate: DateTime.now(),
        ),
      ]);

      final stores = results[0] as List<Map<String, dynamic>>;
      final appointments = results[1] as List<Map<String, dynamic>>;

      emit(HomeLoaded(
        stores: stores,
        nextAppointment: appointments.isNotEmpty ? appointments.first : null,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _appointmentsRepository.cancelAppointment(event.appointmentId);
      add(LoadHomeData());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
