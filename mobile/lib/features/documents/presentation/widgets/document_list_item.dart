import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monscolis/core/widgets/custom_button.dart';

class DocumentListItem extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback? onView;

  const DocumentListItem({
    super.key,
    required this.document,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final uploadDate = DateTime.parse(document['upload_date']);
    final dateFormat = DateFormat('MMM d, yyyy');
    final status = document['status'];

    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getDocumentTypeIcon(document['type']),
                  size: 24,
                  color: Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDocumentTypeName(document['type']),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Uploaded on ${dateFormat.format(uploadDate)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Icon(
                  statusIcon,
                  color: statusColor,
                ),
              ],
            ),
            if (document['comment'] != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.comment,
                      size: 16,
                      color: statusColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        document['comment'],
                        style: TextStyle(color: statusColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (onView != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: 'View Document',
                    onPressed: onView,
                    variant: ButtonVariant.outlined,
                    icon: Icons.visibility,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getDocumentTypeIcon(String type) {
    switch (type) {
      case 'id_card':
        return Icons.credit_card;
      case 'proof_of_residence':
        return Icons.home;
      case 'income_statement':
        return Icons.euro;
      case 'family_composition':
        return Icons.family_restroom;
      default:
        return Icons.description;
    }
  }

  String _getDocumentTypeName(String type) {
    return type.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
