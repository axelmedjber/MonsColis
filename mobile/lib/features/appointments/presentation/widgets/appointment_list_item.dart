import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monscolis/core/widgets/custom_button.dart';

class AppointmentListItem extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback? onCancel;
  final bool isPast;

  const AppointmentListItem({
    super.key,
    required this.appointment,
    this.onCancel,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    final store = appointment['store'];
    final appointmentTime = DateTime.parse(appointment['appointment_time']);
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('HH:mm');
    final isCancelled = appointment['status'] == 'cancelled';

    Color statusColor = Theme.of(context).colorScheme.primary;
    if (isCancelled) {
      statusColor = Colors.red;
    } else if (isPast) {
      statusColor = Colors.grey;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store['name'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dateFormat.format(appointmentTime)} at ${timeFormat.format(appointmentTime)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isCancelled
                        ? 'Cancelled'
                        : isPast
                            ? 'Completed'
                            : 'Scheduled',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (appointment['confirmation_code'] != null &&
                !isPast &&
                !isCancelled) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.confirmation_number, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    appointment['confirmation_code'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
            if (!isPast && !isCancelled && onCancel != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: 'Cancel',
                    onPressed: onCancel,
                    variant: ButtonVariant.outlined,
                    icon: Icons.close,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
