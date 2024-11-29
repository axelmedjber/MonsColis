import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StoreInfoSection extends StatelessWidget {
  final Map<String, dynamic> store;

  const StoreInfoSection({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.store,
            size: 64,
            color: Colors.grey,
          ),
        ),
        Padding(
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
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                store['address'],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildCapacityIndicator(context),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Operating Hours',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildOperatingHours(context),
              if (store['description'] != null) ...[
                const SizedBox(height: 24),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  store['description'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (store['requirements'] != null) ...[
                const SizedBox(height: 24),
                Text(
                  'Requirements',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...List<String>.from(store['requirements']).map(
                  (requirement) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(requirement),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCapacityIndicator(BuildContext context) {
    final capacity = store['capacity'];
    final currentCapacity = store['current_capacity'] ?? 0;
    final percentage = (currentCapacity / capacity * 100).round();

    Color indicatorColor;
    if (percentage < 50) {
      indicatorColor = Colors.green;
    } else if (percentage < 80) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = Colors.red;
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: currentCapacity / capacity,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            ),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Capacity',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildOperatingHours(BuildContext context) {
    final hours = Map<String, List<String>>.from(store['operating_hours']);
    final today = DateTime.now().weekday;
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];

    return Column(
      children: dayNames.asMap().entries.map((entry) {
        final index = entry.key;
        final dayName = entry.value;
        final isToday = index + 1 == today;
        final dayHours = hours[dayName] ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  toBeginningOfSentenceCase(dayName)!,
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : null,
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  dayHours.isEmpty ? 'Closed' : dayHours.join(', '),
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : null,
                    color: dayHours.isEmpty ? Colors.red : null,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
