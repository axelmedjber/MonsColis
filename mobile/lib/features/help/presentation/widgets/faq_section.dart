import 'package:flutter/material.dart';

class FAQSection extends StatelessWidget {
  const FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildFAQCategory(
          context,
          'Getting Started',
          [
            {
              'question': 'How do I register for MonsColis?',
              'answer':
                  'To register, you need to provide your phone number for verification. Once verified, you\'ll need to submit required documents to prove your eligibility for social grocery services.',
            },
            {
              'question': 'What documents do I need to submit?',
              'answer':
                  'Required documents include: ID card, proof of residence in Mons, income statement, and family composition document. These can be uploaded through the Documents section.',
            },
          ],
        ),
        _buildFAQCategory(
          context,
          'Appointments',
          [
            {
              'question': 'How do I book an appointment?',
              'answer':
                  'You can book an appointment by selecting a store from the home screen, choosing an available date and time slot, and confirming your booking.',
            },
            {
              'question': 'Can I cancel or reschedule my appointment?',
              'answer':
                  'Yes, you can cancel or reschedule your appointment up to 24 hours before the scheduled time through the Appointments section.',
            },
          ],
        ),
        _buildFAQCategory(
          context,
          'Documents',
          [
            {
              'question': 'How long does document verification take?',
              'answer':
                  'Document verification typically takes 2-3 business days. You\'ll receive a notification once your documents have been reviewed.',
            },
            {
              'question': 'What if my documents are rejected?',
              'answer':
                  'If your documents are rejected, you\'ll receive a notification explaining why. You can then upload new documents addressing the issues.',
            },
          ],
        ),
        _buildFAQCategory(
          context,
          'Technical Issues',
          [
            {
              'question': 'What if I can\'t log in?',
              'answer':
                  'If you\'re having trouble logging in, make sure you\'re using the correct phone number. You can request a new verification code if needed.',
            },
            {
              'question': 'How do I update my information?',
              'answer':
                  'You can update your personal information through the Profile section. Some changes may require new document verification.',
            },
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search FAQ',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (query) {
        // TODO: Implement FAQ search
      },
    );
  }

  Widget _buildFAQCategory(
    BuildContext context,
    String title,
    List<Map<String, String>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Card(
          child: Column(
            children: items.map((item) {
              return ExpansionTile(
                title: Text(
                  item['question']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      item['answer']!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
