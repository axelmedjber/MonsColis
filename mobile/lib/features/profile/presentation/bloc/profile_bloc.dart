import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:monscolis/features/profile/data/profile_repository.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> profileData;

  const UpdateProfile(this.profileData);

  @override
  List<Object> get props => [profileData];
}

class ChangeLanguage extends ProfileEvent {
  final String languageCode;

  const ChangeLanguage(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class ToggleNotifications extends ProfileEvent {
  final bool enabled;

  const ToggleNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class LogOut extends ProfileEvent {}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> profile;
  final Map<String, dynamic> settings;

  const ProfileLoaded({
    required this.profile,
    required this.settings,
  });

  @override
  List<Object> get props => [profile, settings];

  ProfileLoaded copyWith({
    Map<String, dynamic>? profile,
    Map<String, dynamic>? settings,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      settings: settings ?? this.settings,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class LoggedOut extends ProfileState {}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository(),
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ToggleNotifications>(_onToggleNotifications);
    on<LogOut>(_onLogOut);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      final profile = await _repository.getProfile();
      final settings = await _repository.getSettings();

      emit(ProfileLoaded(
        profile: profile,
        settings: settings,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(ProfileLoading());

        final updatedProfile = await _repository.updateProfile(
          event.profileData,
        );

        emit(currentState.copyWith(profile: updatedProfile));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final updatedSettings = Map<String, dynamic>.from(currentState.settings)
          ..['language'] = event.languageCode;

        await _repository.updateSettings(updatedSettings);
        emit(currentState.copyWith(settings: updatedSettings));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final updatedSettings = Map<String, dynamic>.from(currentState.settings)
          ..['notifications_enabled'] = event.enabled;

        await _repository.updateSettings(updatedSettings);
        emit(currentState.copyWith(settings: updatedSettings));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogOut(
    LogOut event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _repository.logOut();
      emit(LoggedOut());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
