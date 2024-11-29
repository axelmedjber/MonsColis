import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSlotPicker extends StatelessWidget {
  final List<DateTime> availableSlots;
  final DateTime? selectedSlot;
  final ValueChanged<DateTime>? onSlotSelected;

  const TimeSlotPicker({
    super.key,
    required this.availableSlots,
    this.selectedSlot,
    this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (availableSlots.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Icon(
              Icons.event_busy,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No available slots for this date',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableSlots.map((slot) {
            final isSelected = selectedSlot == slot;
            final timeFormat = DateFormat('HH:mm');

            return InkWell(
              onTap: () => onSlotSelected?.call(slot),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  timeFormat.format(slot),
                  style: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
