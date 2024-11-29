import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Markdown(
        data: '''
# Privacy Policy

Last updated: ${DateTime.now().year}

## 1. Introduction

MonsColis ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and share your information when you use our mobile application.

## 2. Information We Collect

### 2.1 Personal Information
- Full name
- Phone number
- Address
- Identity documents
- Income statements
- Family composition documents

### 2.2 Usage Information
- App usage statistics
- Device information
- Location data (when using store locator)
- Appointment history

## 3. How We Use Your Information

We use your information to:
- Verify your eligibility for social grocery services
- Process and manage your appointments
- Send notifications about your appointments and documents
- Improve our services
- Comply with legal obligations

## 4. Information Sharing

We share your information with:
- Social grocery stores (only necessary appointment details)
- Government agencies (when required by law)
- Service providers (for app functionality)

We never sell your personal information to third parties.

## 5. Data Security

We implement appropriate security measures to protect your information, including:
- Encryption of sensitive data
- Secure server infrastructure
- Regular security audits
- Access controls

## 6. Your Rights

You have the right to:
- Access your personal information
- Correct inaccurate information
- Request deletion of your information
- Opt-out of communications
- File a complaint with authorities

## 7. Data Retention

We retain your information for as long as:
- Your account is active
- Required by law
- Necessary for legitimate business purposes

## 8. Children's Privacy

Our service is not intended for children under 18. We do not knowingly collect information from children.

## 9. Changes to This Policy

We may update this Privacy Policy. We will notify you of any changes through the app.

## 10. Contact Us

For privacy-related questions:
- Email: privacy@monscolis.be
- Phone: +32 65 12 34 56
- Address: 123 Rue de Mons, 7000 Mons

## 11. Legal Basis

We process your information based on:
- Your consent
- Contract fulfillment
- Legal obligations
- Legitimate interests

## 12. International Data Transfers

Your data is stored and processed in Belgium, in compliance with GDPR requirements.
''',
        styleSheet: MarkdownStyleSheet(
          h1: Theme.of(context).textTheme.headlineMedium,
          h2: Theme.of(context).textTheme.titleLarge,
          p: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
