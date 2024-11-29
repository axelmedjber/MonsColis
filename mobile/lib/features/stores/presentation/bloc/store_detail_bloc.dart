import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:monscolis/features/stores/data/stores_repository.dart';

// Events
abstract class StoreDetailEvent extends Equatable {
  const StoreDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadStoreDetail extends StoreDetailEvent {
  final String storeId;

  const LoadStoreDetail(this.storeId);

  @override
  List<Object> get props => [storeId];
}

class LoadAvailableSlots extends StoreDetailEvent {
  final String storeId;
  final DateTime date;

  const LoadAvailableSlots({
    required this.storeId,
    required this.date,
  });

  @override
  List<Object> get props => [storeId, date];
}

class BookAppointment extends StoreDetailEvent {
  final String storeId;
  final DateTime dateTime;

  const BookAppointment({
    required this.storeId,
    required this.dateTime,
  });

  @override
  List<Object> get props => [storeId, dateTime];
}

// States
abstract class StoreDetailState extends Equatable {
  const StoreDetailState();

  @override
  List<Object> get props => [];
}

class StoreDetailInitial extends StoreDetailState {}

class StoreDetailLoading extends StoreDetailState {}

class StoreDetailLoaded extends StoreDetailState {
  final Map<String, dynamic> store;
  final List<DateTime>? availableSlots;

  const StoreDetailLoaded({
    required this.store,
    this.availableSlots,
  });

  @override
  List<Object> get props => [
        store,
        if (availableSlots != null) availableSlots!,
      ];

  StoreDetailLoaded copyWith({
    Map<String, dynamic>? store,
    List<DateTime>? availableSlots,
  }) {
    return StoreDetailLoaded(
      store: store ?? this.store,
      availableSlots: availableSlots ?? this.availableSlots,
    );
  }
}

class BookingSuccess extends StoreDetailState {
  final Map<String, dynamic> appointment;

  const BookingSuccess(this.appointment);

  @override
  List<Object> get props => [appointment];
}

class StoreDetailError extends StoreDetailState {
  final String message;

  const StoreDetailError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class StoreDetailBloc extends Bloc<StoreDetailEvent, StoreDetailState> {
  final StoresRepository _repository;

  StoreDetailBloc({StoresRepository? repository})
      : _repository = repository ?? StoresRepository(),
        super(StoreDetailInitial()) {
    on<LoadStoreDetail>(_onLoadStoreDetail);
    on<LoadAvailableSlots>(_onLoadAvailableSlots);
    on<BookAppointment>(_onBookAppointment);
  }

  Future<void> _onLoadStoreDetail(
    LoadStoreDetail event,
    Emitter<StoreDetailState> emit,
  ) async {
    try {
      emit(StoreDetailLoading());

      final store = await _repository.getStoreById(event.storeId);
      emit(StoreDetailLoaded(store: store));
    } catch (e) {
      emit(StoreDetailError(e.toString()));
    }
  }

  Future<void> _onLoadAvailableSlots(
    LoadAvailableSlots event,
    Emitter<StoreDetailState> emit,
  ) async {
    try {
      if (state is StoreDetailLoaded) {
        final currentState = state as StoreDetailLoaded;
        emit(currentState.copyWith(availableSlots: null));

        final slots = await _repository.getAvailableSlots(
          event.storeId,
          event.date,
        );

        emit(currentState.copyWith(availableSlots: slots));
      }
    } catch (e) {
      emit(StoreDetailError(e.toString()));
    }
  }

  Future<void> _onBookAppointment(
    BookAppointment event,
    Emitter<StoreDetailState> emit,
  ) async {
    try {
      emit(StoreDetailLoading());

      final appointment = await _repository.bookAppointment(
        event.storeId,
        event.dateTime,
      );

      emit(BookingSuccess(appointment));
    } catch (e) {
      emit(StoreDetailError(e.toString()));
    }
  }
}
