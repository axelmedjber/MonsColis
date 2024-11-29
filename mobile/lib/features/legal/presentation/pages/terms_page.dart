import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: Markdown(
        data: '''
# Terms of Service

Last updated: ${DateTime.now().year}

## 1. Acceptance of Terms

By accessing or using MonsColis, you agree to be bound by these Terms of Service.

## 2. Eligibility

### 2.1 General Requirements
- Must be 18 years or older
- Resident of Mons, Belgium
- Meet social assistance criteria

### 2.2 Documentation
You must provide valid:
- Identity documents
- Proof of residence
- Income statements
- Family composition documents

## 3. User Accounts

### 3.1 Registration
- Provide accurate information
- Maintain current contact details
- Keep account credentials secure

### 3.2 Account Termination
We may suspend or terminate accounts for:
- Violation of terms
- Fraudulent activity
- Misuse of services

## 4. Services

### 4.1 Appointment Booking
- Book appointments within available slots
- Cancel at least 24 hours in advance
- Arrive on time for appointments

### 4.2 Document Verification
- Submit authentic documents
- Allow processing time
- Respond to verification requests

## 5. User Responsibilities

You agree to:
- Follow store rules and guidelines
- Respect staff and other users
- Use services as intended
- Report issues promptly

## 6. Limitations of Service

### 6.1 Availability
- Services subject to store capacity
- Operating hours may vary
- System maintenance periods

### 6.2 Modifications
We may modify:
- Available services
- Operating hours
- Eligibility criteria

## 7. Communication

We may contact you via:
- Phone
- SMS
- In-app notifications
- Email

## 8. Intellectual Property

All content and features are owned by MonsColis and protected by law.

## 9. Disclaimer of Warranties

Services provided "as is" without warranties of any kind.

## 10. Limitation of Liability

We are not liable for:
- Service interruptions
- Data loss
- Indirect damages

## 11. Governing Law

These terms are governed by Belgian law.

## 12. Changes to Terms

We may update these terms. Continued use constitutes acceptance.

## 13. Contact Information

For questions about these terms:
- Email: legal@monscolis.be
- Phone: +32 65 12 34 56
- Address: 123 Rue de Mons, 7000 Mons

## 14. Termination

### 14.1 By Users
You may terminate your account at any time.

### 14.2 By MonsColis
We may terminate services for violations of these terms.

## 15. Severability

If any provision is invalid, other provisions remain in effect.
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
