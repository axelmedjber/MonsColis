import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monscolis/core/widgets/custom_button.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback? onCancel;

  const UpcomingAppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final store = appointment['store'];
    final appointmentTime = DateTime.parse(appointment['appointment_time']);
    final dateFormat = DateFormat('EEEE, MMMM d');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(appointmentTime),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'at ${timeFormat.format(appointmentTime)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.store),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store['name'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        store['address'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (appointment['confirmation_code'] != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.confirmation_number),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirmation Code',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        appointment['confirmation_code'],
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Get Directions',
                    onPressed: () {
                      // TODO: Open maps with store location
                    },
                    icon: Icons.directions,
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Cancel',
                  onPressed: onCancel,
                  variant: ButtonVariant.outlined,
                  icon: Icons.close,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
