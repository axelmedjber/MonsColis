import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monscolis/features/stores/data/stores_repository.dart';
import 'package:monscolis/features/stores/presentation/bloc/store_detail_bloc.dart';

class MockStoresRepository extends Mock implements StoresRepository {}

void main() {
  late StoreDetailBloc storeDetailBloc;
  late MockStoresRepository mockRepository;

  final testStore = {
    'id': '1',
    'name': 'Test Store',
    'address': '123 Test St',
    'capacity': 50,
    'current_capacity': 25,
    'operating_hours': {
      'monday': ['9:00-17:00'],
      'tuesday': ['9:00-17:00'],
      'wednesday': ['9:00-17:00'],
      'thursday': ['9:00-17:00'],
      'friday': ['9:00-17:00'],
    },
  };

  final testSlots = [
    DateTime(2024, 1, 1, 9, 0),
    DateTime(2024, 1, 1, 10, 0),
    DateTime(2024, 1, 1, 11, 0),
  ];

  final testAppointment = {
    'id': '1',
    'store_id': '1',
    'appointment_time': '2024-01-01T09:00:00Z',
    'status': 'scheduled',
  };

  setUp(() {
    mockRepository = MockStoresRepository();
    storeDetailBloc = StoreDetailBloc(repository: mockRepository);
  });

  tearDown(() {
    storeDetailBloc.close();
  });

  group('StoreDetailBloc', () {
    test('initial state is StoreDetailInitial', () {
      expect(storeDetailBloc.state, isA<StoreDetailInitial>());
    });

    blocTest<StoreDetailBloc, StoreDetailState>(
      'emits [StoreDetailLoading, StoreDetailLoaded] when LoadStoreDetail is added',
      build: () {
        when(() => mockRepository.getStoreById(any()))
            .thenAnswer((_) async => testStore);
        return storeDetailBloc;
      },
      act: (bloc) => bloc.add(LoadStoreDetail('1')),
      expect: () => [
        isA<StoreDetailLoading>(),
        isA<StoreDetailLoaded>()
            .having((state) => state.store, 'store', testStore),
      ],
      verify: (_) {
        verify(() => mockRepository.getStoreById('1')).called(1);
      },
    );

    blocTest<StoreDetailBloc, StoreDetailState>(
      'emits updated StoreDetailLoaded when LoadAvailableSlots is added',
      build: () {
        when(() => mockRepository.getAvailableSlots(any(), any()))
            .thenAnswer((_) async => testSlots);
        return storeDetailBloc;
      },
      seed: () => StoreDetailLoaded(store: testStore),
      act: (bloc) => bloc.add(
        LoadAvailableSlots(
          storeId: '1',
          date: DateTime(2024, 1, 1),
        ),
      ),
      expect: () => [
        isA<StoreDetailLoaded>()
            .having((state) => state.store, 'store', testStore)
            .having((state) => state.availableSlots, 'availableSlots', testSlots),
      ],
      verify: (_) {
        verify(() => mockRepository.getAvailableSlots(
              '1',
              DateTime(2024, 1, 1),
            )).called(1);
      },
    );

    blocTest<StoreDetailBloc, StoreDetailState>(
      'emits [StoreDetailLoading, BookingSuccess] when BookAppointment is added',
      build: () {
        when(() => mockRepository.bookAppointment(any(), any()))
            .thenAnswer((_) async => testAppointment);
        return storeDetailBloc;
      },
      act: (bloc) => bloc.add(
        BookAppointment(
          storeId: '1',
          dateTime: DateTime(2024, 1, 1, 9, 0),
        ),
      ),
      expect: () => [
        isA<StoreDetailLoading>(),
        isA<BookingSuccess>()
            .having((state) => state.appointment, 'appointment', testAppointment),
      ],
      verify: (_) {
        verify(() => mockRepository.bookAppointment(
              '1',
              DateTime(2024, 1, 1, 9, 0),
            )).called(1);
      },
    );

    blocTest<StoreDetailBloc, StoreDetailState>(
      'emits [StoreDetailLoading, StoreDetailError] when repository throws',
      build: () {
        when(() => mockRepository.getStoreById(any()))
            .thenThrow(Exception('Test error'));
        return storeDetailBloc;
      },
      act: (bloc) => bloc.add(LoadStoreDetail('1')),
      expect: () => [
        isA<StoreDetailLoading>(),
        isA<StoreDetailError>().having(
          (state) => state.message,
          'message',
          'Exception: Test error',
        ),
      ],
    );
  });
}
