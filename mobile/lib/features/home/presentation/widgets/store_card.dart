import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  final Map<String, dynamic> store;
  final VoidCallback? onTap;

  const StoreCard({
    super.key,
    required this.store,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.store,
                size: 48,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store['name'],
                    style: Theme.of(context).textTheme.titleLarge,
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Capacity: ${store['capacity']} people',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (store['operating_hours'] != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Today: ${_getTodayHours(store['operating_hours'])}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTodayHours(Map<String, dynamic> hours) {
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
    final todayHours = hours[dayNames[today - 1]];
    if (todayHours == null || todayHours.isEmpty) {
      return 'Closed';
    }
    return todayHours.join(', ');
  }
}
