import 'package:flutter/material.dart';
import 'package:monscolis/features/help/presentation/widgets/faq_section.dart';
import 'package:monscolis/features/help/presentation/widgets/contact_support_section.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Help & Support'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.question_answer),
                text: 'FAQ',
              ),
              Tab(
                icon: Icon(Icons.contact_support),
                text: 'Contact',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FAQSection(),
            ContactSupportSection(),
          ],
        ),
      ),
    );
  }
}
