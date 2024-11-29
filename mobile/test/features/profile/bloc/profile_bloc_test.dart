import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monscolis/features/profile/data/profile_repository.dart';
import 'package:monscolis/features/profile/presentation/bloc/profile_bloc.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProfileBloc profileBloc;
  late MockProfileRepository mockRepository;

  final testProfile = {
    'name': 'John Doe',
    'phone': '+32123456789',
    'address': '123 Test St',
    'status': 'verified',
  };

  final testSettings = {
    'language': 'en',
    'notifications_enabled': true,
    'dark_mode': false,
  };

  setUp(() {
    mockRepository = MockProfileRepository();
    profileBloc = ProfileBloc(repository: mockRepository);
  });

  tearDown(() {
    profileBloc.close();
  });

  group('ProfileBloc', () {
    test('initial state is ProfileInitial', () {
      expect(profileBloc.state, isA<ProfileInitial>());
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when LoadProfile is added',
      build: () {
        when(() => mockRepository.getProfile())
            .thenAnswer((_) async => testProfile);
        when(() => mockRepository.getSettings())
            .thenAnswer((_) async => testSettings);
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadProfile()),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileLoaded>()
            .having((state) => state.profile, 'profile', testProfile)
            .having((state) => state.settings, 'settings', testSettings),
      ],
      verify: (_) {
        verify(() => mockRepository.getProfile()).called(1);
        verify(() => mockRepository.getSettings()).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when UpdateProfile is added',
      build: () {
        when(() => mockRepository.updateProfile(any()))
            .thenAnswer((_) async => testProfile);
        return profileBloc;
      },
      seed: () => ProfileLoaded(profile: testProfile, settings: testSettings),
      act: (bloc) => bloc.add(UpdateProfile(testProfile)),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileLoaded>()
            .having((state) => state.profile, 'profile', testProfile)
            .having((state) => state.settings, 'settings', testSettings),
      ],
      verify: (_) {
        verify(() => mockRepository.updateProfile(testProfile)).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoaded] with updated settings when ChangeLanguage is added',
      build: () {
        when(() => mockRepository.updateSettings(any()))
            .thenAnswer((_) async => {});
        return profileBloc;
      },
      seed: () => ProfileLoaded(profile: testProfile, settings: testSettings),
      act: (bloc) => bloc.add(const ChangeLanguage('fr')),
      expect: () => [
        isA<ProfileLoaded>().having(
          (state) => state.settings['language'],
          'language',
          'fr',
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.updateSettings(any())).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoaded] with updated settings when ToggleNotifications is added',
      build: () {
        when(() => mockRepository.updateSettings(any()))
            .thenAnswer((_) async => {});
        return profileBloc;
      },
      seed: () => ProfileLoaded(profile: testProfile, settings: testSettings),
      act: (bloc) => bloc.add(const ToggleNotifications(false)),
      expect: () => [
        isA<ProfileLoaded>().having(
          (state) => state.settings['notifications_enabled'],
          'notifications_enabled',
          false,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.updateSettings(any())).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [LoggedOut] when LogOut is added',
      build: () {
        when(() => mockRepository.logOut()).thenAnswer((_) async => {});
        return profileBloc;
      },
      act: (bloc) => bloc.add(LogOut()),
      expect: () => [isA<LoggedOut>()],
      verify: (_) {
        verify(() => mockRepository.logOut()).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileError] when repository throws',
      build: () {
        when(() => mockRepository.getProfile())
            .thenThrow(Exception('Test error'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadProfile()),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileError>().having(
          (state) => state.message,
          'message',
          'Exception: Test error',
        ),
      ],
    );
  });
}
