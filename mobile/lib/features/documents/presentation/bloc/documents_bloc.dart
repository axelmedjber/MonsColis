import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:monscolis/features/documents/data/documents_repository.dart';

// Events
abstract class DocumentsEvent extends Equatable {
  const DocumentsEvent();

  @override
  List<Object> get props => [];
}

class LoadDocuments extends DocumentsEvent {}

class UploadDocument extends DocumentsEvent {
  final String documentType;
  final List<int> fileBytes;
  final String fileName;

  const UploadDocument({
    required this.documentType,
    required this.fileBytes,
    required this.fileName,
  });

  @override
  List<Object> get props => [documentType, fileBytes, fileName];
}

class GetDocumentUrl extends DocumentsEvent {
  final String documentId;

  const GetDocumentUrl(this.documentId);

  @override
  List<Object> get props => [documentId];
}

// States
abstract class DocumentsState extends Equatable {
  const DocumentsState();

  @override
  List<Object> get props => [];
}

class DocumentsInitial extends DocumentsState {}

class DocumentsLoading extends DocumentsState {}

class DocumentsLoaded extends DocumentsState {
  final List<Map<String, dynamic>> pendingDocuments;
  final List<Map<String, dynamic>> approvedDocuments;
  final List<Map<String, dynamic>> rejectedDocuments;

  const DocumentsLoaded({
    required this.pendingDocuments,
    required this.approvedDocuments,
    required this.rejectedDocuments,
  });

  @override
  List<Object> get props => [
        pendingDocuments,
        approvedDocuments,
        rejectedDocuments,
      ];
}

class DocumentUrlLoaded extends DocumentsState {
  final String url;

  const DocumentUrlLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class DocumentsError extends DocumentsState {
  final String message;

  const DocumentsError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  final DocumentsRepository _repository;

  DocumentsBloc({DocumentsRepository? repository})
      : _repository = repository ?? DocumentsRepository(),
        super(DocumentsInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<UploadDocument>(_onUploadDocument);
    on<GetDocumentUrl>(_onGetDocumentUrl);
  }

  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      emit(DocumentsLoading());

      final documents = await _repository.getDocuments();

      final pendingDocuments =
          documents.where((d) => d['status'] == 'pending').toList();
      final approvedDocuments =
          documents.where((d) => d['status'] == 'approved').toList();
      final rejectedDocuments =
          documents.where((d) => d['status'] == 'rejected').toList();

      emit(DocumentsLoaded(
        pendingDocuments: pendingDocuments,
        approvedDocuments: approvedDocuments,
        rejectedDocuments: rejectedDocuments,
      ));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onUploadDocument(
    UploadDocument event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      emit(DocumentsLoading());

      await _repository.uploadDocument(
        event.documentType,
        event.fileBytes,
        event.fileName,
      );

      add(LoadDocuments());
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onGetDocumentUrl(
    GetDocumentUrl event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      final url = await _repository.getDocumentUrl(event.documentId);
      emit(DocumentUrlLoaded(url));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
}
