import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monscolis/features/documents/presentation/bloc/documents_bloc.dart';
import 'package:file_picker/file_picker.dart';

class UploadDocumentButton extends StatelessWidget {
  const UploadDocumentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showUploadDialog(context),
      icon: const Icon(Icons.upload_file),
      label: const Text('Upload Document'),
    );
  }

  Future<void> _showUploadDialog(BuildContext context) async {
    final documentTypes = [
      'id_card',
      'proof_of_residence',
      'income_statement',
      'family_composition',
    ];

    String? selectedType;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Document'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Document Type',
                  border: OutlineInputBorder(),
                ),
                items: documentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      type.split('_').map((word) {
                        return word[0].toUpperCase() + word.substring(1);
                      }).join(' '),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: selectedType == null
                ? null
                : () async {
                    Navigator.pop(context);
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                    );

                    if (result != null && result.files.isNotEmpty) {
                      final file = result.files.first;
                      if (file.bytes != null) {
                        context.read<DocumentsBloc>().add(
                              UploadDocument(
                                documentType: selectedType!,
                                fileBytes: file.bytes!,
                                fileName: file.name,
                              ),
                            );
                      }
                    }
                  },
            child: const Text('Choose File'),
          ),
        ],
      ),
    );
  }
}
