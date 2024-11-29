import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monscolis/core/widgets/error_view.dart';
import 'package:monscolis/core/widgets/loading_overlay.dart';
import 'package:monscolis/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:monscolis/features/profile/presentation/widgets/profile_header.dart';
import 'package:monscolis/features/profile/presentation/widgets/settings_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LoggedOut) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Profile')),
              body: ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<ProfileBloc>().add(LoadProfile());
                },
              ),
            );
          }

          if (state is ProfileLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/profile/edit',
                        arguments: state.profile,
                      );
                    },
                  ),
                ],
              ),
              body: LoadingOverlay(
                isLoading: state is ProfileLoading,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileHeader(profile: state.profile),
                      const Divider(height: 32),
                      SettingsSection(
                        settings: state.settings,
                        onLanguageChanged: (language) {
                          context
                              .read<ProfileBloc>()
                              .add(ChangeLanguage(language));
                        },
                        onNotificationsToggled: (enabled) {
                          context
                              .read<ProfileBloc>()
                              .add(ToggleNotifications(enabled));
                        },
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.help_outline),
                              title: const Text('Help & Support'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.pushNamed(context, '/help');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.privacy_tip_outlined),
                              title: const Text('Privacy Policy'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.pushNamed(context, '/privacy');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.description_outlined),
                              title: const Text('Terms of Service'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.pushNamed(context, '/terms');
                              },
                            ),
                            const Divider(height: 32),
                            ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Log Out',
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Log Out'),
                                    content: const Text(
                                      'Are you sure you want to log out?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context
                                              .read<ProfileBloc>()
                                              .add(LogOut());
                                        },
                                        child: const Text(
                                          'Log Out',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
