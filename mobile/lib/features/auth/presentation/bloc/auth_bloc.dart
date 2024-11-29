import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendVerificationCode extends AuthEvent {
  final String phoneNumber;

  const SendVerificationCode(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyPhoneNumber extends AuthEvent {
  final String phoneNumber;
  final String verificationCode;

  const VerifyPhoneNumber(this.phoneNumber, this.verificationCode);

  @override
  List<Object> get props => [phoneNumber, verificationCode];
}

class LogOut extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class CodeSent extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  final Map<String, dynamic> user;

  const AuthSuccess(this.token, this.user);

  @override
  List<Object> get props => [token, user];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SendVerificationCode>(_onSendVerificationCode);
    on<VerifyPhoneNumber>(_onVerifyPhoneNumber);
    on<LogOut>(_onLogOut);
  }

  Future<void> _onSendVerificationCode(
    SendVerificationCode event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      // TODO: Implement API call
      emit(CodeSent());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyPhoneNumber(
    VerifyPhoneNumber event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      // TODO: Implement API call
      emit(const AuthSuccess('dummy_token', {'id': 'dummy_id'}));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogOut(
    LogOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      // TODO: Clear local storage
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
