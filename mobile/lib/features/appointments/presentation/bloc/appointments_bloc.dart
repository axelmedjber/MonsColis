import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:monscolis/features/appointments/data/appointments_repository.dart';

// Events
abstract class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object> get props => [];
}

class LoadAppointments extends AppointmentsEvent {}

class CancelAppointment extends AppointmentsEvent {
  final String appointmentId;

  const CancelAppointment(this.appointmentId);

  @override
  List<Object> get props => [appointmentId];
}

// States
abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object> get props => [];
}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<Map<String, dynamic>> upcomingAppointments;
  final List<Map<String, dynamic>> pastAppointments;

  const AppointmentsLoaded({
    required this.upcomingAppointments,
    required this.pastAppointments,
  });

  @override
  List<Object> get props => [upcomingAppointments, pastAppointments];
}

class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final AppointmentsRepository _repository;

  AppointmentsBloc({AppointmentsRepository? repository})
      : _repository = repository ?? AppointmentsRepository(),
        super(AppointmentsInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<CancelAppointment>(_onCancelAppointment);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      emit(AppointmentsLoading());

      final now = DateTime.now();
      final allAppointments = await _repository.getAppointments();

      final upcomingAppointments = allAppointments
          .where((a) =>
              DateTime.parse(a['appointment_time']).isAfter(now) &&
              a['status'] == 'scheduled')
          .toList()
        ..sort((a, b) => DateTime.parse(a['appointment_time'])
            .compareTo(DateTime.parse(b['appointment_time'])));

      final pastAppointments = allAppointments
          .where((a) =>
              DateTime.parse(a['appointment_time']).isBefore(now) ||
              a['status'] == 'cancelled')
          .toList()
        ..sort((a, b) => DateTime.parse(b['appointment_time'])
            .compareTo(DateTime.parse(a['appointment_time'])));

      emit(AppointmentsLoaded(
        upcomingAppointments: upcomingAppointments,
        pastAppointments: pastAppointments,
      ));
    } catch (e) {
      emit(AppointmentsError(e.toString()));
    }
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      await _repository.cancelAppointment(event.appointmentId);
      add(LoadAppointments());
    } catch (e) {
      emit(AppointmentsError(e.toString()));
    }
  }
}
