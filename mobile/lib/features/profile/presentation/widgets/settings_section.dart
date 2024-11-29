import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final Map<String, dynamic> settings;
  final ValueChanged<String>? onLanguageChanged;
  final ValueChanged<bool>? onNotificationsToggled;

  const SettingsSection({
    super.key,
    required this.settings,
    this.onLanguageChanged,
    this.onNotificationsToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  trailing: DropdownButton<String>(
                    value: settings['language'],
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'fr',
                        child: Text('Français'),
                      ),
                      DropdownMenuItem(
                        value: 'nl',
                        child: Text('Nederlands'),
                      ),
                    ],
                    onChanged: onLanguageChanged,
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  subtitle: Text(
                    'Receive updates about your appointments and documents',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  value: settings['notifications_enabled'] ?? false,
                  onChanged: onNotificationsToggled,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: settings['dark_mode'] ?? false,
                    onChanged: (value) {
                      // TODO: Implement theme switching
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Clear Cache'),
                  subtitle: Text(
                    'Free up space by clearing cached data',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear Cache'),
                          content: const Text(
                            'Are you sure you want to clear all cached data? '
                            'This will not affect your account or saved information.',
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
                                // TODO: Implement cache clearing
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cache cleared successfully'),
                                  ),
                                );
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
