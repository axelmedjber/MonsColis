import 'package:flutter/material.dart';
import 'package:monscolis/core/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportSection extends StatelessWidget {
  const ContactSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Hours',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Monday - Friday: 9:00 - 17:00'),
                  const Text('Saturday: 9:00 - 12:00'),
                  const Text('Sunday: Closed'),
                  const Divider(height: 32),
                  Text(
                    'Emergency Contact',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'For urgent matters outside of regular hours:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Text('Emergency Hotline: +32 800 12345'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Get in Touch',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Call Support'),
                  subtitle: const Text('+32 65 12 34 56'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _launchUrl('tel:+3265123456'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Support'),
                  subtitle: const Text('support@monscolis.be'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _launchUrl('mailto:support@monscolis.be'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Visit Us'),
                  subtitle: const Text('123 Rue de Mons, 7000 Mons'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _launchUrl(
                    'https://www.google.com/maps/search/?api=1&query=123+Rue+de+Mons+7000+Mons',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Send us a Message',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Send Message',
                    onPressed: () {
                      // TODO: Implement message sending
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Message sent successfully'),
                        ),
                      );
                    },
                    icon: Icons.send,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Follow Us',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.facebook),
                  title: const Text('Facebook'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _launchUrl('https://facebook.com/monscolis'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.web),
                  title: const Text('Website'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _launchUrl('https://monscolis.be'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
