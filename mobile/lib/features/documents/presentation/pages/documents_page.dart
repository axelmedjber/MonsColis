import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monscolis/core/widgets/error_view.dart';
import 'package:monscolis/core/widgets/loading_overlay.dart';
import 'package:monscolis/features/documents/presentation/bloc/documents_bloc.dart';
import 'package:monscolis/features/documents/presentation/widgets/document_list_item.dart';
import 'package:monscolis/features/documents/presentation/widgets/upload_document_button.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DocumentsBloc()..add(LoadDocuments()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Documents'),
        ),
        body: BlocBuilder<DocumentsBloc, DocumentsState>(
          builder: (context, state) {
            if (state is DocumentsError) {
              return ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<DocumentsBloc>().add(LoadDocuments());
                },
              );
            }

            return LoadingOverlay(
              isLoading: state is DocumentsLoading,
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<DocumentsBloc>().add(LoadDocuments());
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (state is DocumentsLoaded) ...[
                            if (state.pendingDocuments.isEmpty &&
                                state.approvedDocuments.isEmpty &&
                                state.rejectedDocuments.isEmpty)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.description_outlined,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No documents yet',
                                      style:
                                          Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Upload your documents to verify your eligibility',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            else ...[
                              if (state.pendingDocuments.isNotEmpty) ...[
                                Text(
                                  'Pending Review',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                ...state.pendingDocuments.map(
                                  (document) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: DocumentListItem(
                                      document: document,
                                      onView: () {
                                        context.read<DocumentsBloc>().add(
                                              GetDocumentUrl(document['id']),
                                            );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              if (state.approvedDocuments.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Text(
                                  'Approved',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                ...state.approvedDocuments.map(
                                  (document) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: DocumentListItem(
                                      document: document,
                                      onView: () {
                                        context.read<DocumentsBloc>().add(
                                              GetDocumentUrl(document['id']),
                                            );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              if (state.rejectedDocuments.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Text(
                                  'Rejected',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                ...state.rejectedDocuments.map(
                                  (document) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: DocumentListItem(
                                      document: document,
                                      onView: () {
                                        context.read<DocumentsBloc>().add(
                                              GetDocumentUrl(document['id']),
                                            );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: const UploadDocumentButton(),
      ),
    );
  }
}
