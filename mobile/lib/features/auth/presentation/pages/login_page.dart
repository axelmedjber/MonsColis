import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monscolis/core/widgets/custom_button.dart';
import 'package:monscolis/core/widgets/loading_overlay.dart';
import 'package:monscolis/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _codeSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is CodeSent) {
          setState(() => _codeSent = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification code sent!')),
          );
        } else if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is AuthLoading,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 120,
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Welcome to MonsColis',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your social grocery companion',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixText: '+32 ',
                        hintText: '123 456 789',
                      ),
                      enabled: !_codeSent,
                    ),
                    if (_codeSent) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Verification Code',
                          hintText: '123456',
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    CustomButton(
                      text: _codeSent ? 'Verify Code' : 'Send Code',
                      onPressed: () {
                        if (_codeSent) {
                          context.read<AuthBloc>().add(
                                VerifyPhoneNumber(
                                  _phoneController.text,
                                  _codeController.text,
                                ),
                              );
                        } else {
                          context.read<AuthBloc>().add(
                                SendVerificationCode(_phoneController.text),
                              );
                        }
                      },
                    ),
                    if (_codeSent) ...[
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() => _codeSent = false);
                          _codeController.clear();
                        },
                        child: const Text('Change Phone Number'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
