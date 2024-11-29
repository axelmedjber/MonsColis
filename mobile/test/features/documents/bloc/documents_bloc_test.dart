import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monscolis/features/documents/data/documents_repository.dart';
import 'package:monscolis/features/documents/presentation/bloc/documents_bloc.dart';

class MockDocumentsRepository extends Mock implements DocumentsRepository {}

void main() {
  late DocumentsBloc documentsBloc;
  late MockDocumentsRepository mockRepository;

  final testDocuments = [
    {
      'id': '1',
      'type': 'ID_CARD',
      'status': 'PENDING',
      'uploadDate': '2024-01-01T10:00:00Z',
      'comments': null,
    },
    {
      'id': '2',
      'type': 'PROOF_OF_RESIDENCE',
      'status': 'APPROVED',
      'uploadDate': '2024-01-01T11:00:00Z',
      'comments': 'Document verified',
    },
  ];

  setUp(() {
    mockRepository = MockDocumentsRepository();
    documentsBloc = DocumentsBloc(repository: mockRepository);
  });

  tearDown(() {
    documentsBloc.close();
  });

  group('DocumentsBloc', () {
    test('initial state is DocumentsInitial', () {
      expect(documentsBloc.state, isA<DocumentsInitial>());
    });

    blocTest<DocumentsBloc, DocumentsState>(
      'emits [DocumentsLoading, DocumentsLoaded] when LoadDocuments is added',
      build: () {
        when(() => mockRepository.getDocuments())
            .thenAnswer((_) async => testDocuments);
        return documentsBloc;
      },
      act: (bloc) => bloc.add(LoadDocuments()),
      expect: () => [
        isA<DocumentsLoading>(),
        isA<DocumentsLoaded>()
            .having((state) => state.documents, 'documents', testDocuments),
      ],
      verify: (_) {
        verify(() => mockRepository.getDocuments()).called(1);
      },
    );

    blocTest<DocumentsBloc, DocumentsState>(
      'emits [DocumentsLoading, UploadSuccess] when UploadDocument is added',
      build: () {
        when(() => mockRepository.uploadDocument(any(), any()))
            .thenAnswer((_) async => testDocuments[0]);
        return documentsBloc;
      },
      act: (bloc) => bloc.add(
        UploadDocument(
          type: 'ID_CARD',
          filePath: '/path/to/file.pdf',
        ),
      ),
      expect: () => [
        isA<DocumentsLoading>(),
        isA<UploadSuccess>()
            .having((state) => state.document, 'document', testDocuments[0]),
      ],
      verify: (_) {
        verify(() => mockRepository.uploadDocument('ID_CARD', '/path/to/file.pdf'))
            .called(1);
      },
    );

    blocTest<DocumentsBloc, DocumentsState>(
      'emits [DocumentsLoading, DocumentsError] when repository throws',
      build: () {
        when(() => mockRepository.getDocuments())
            .thenThrow(Exception('Test error'));
        return documentsBloc;
      },
      act: (bloc) => bloc.add(LoadDocuments()),
      expect: () => [
        isA<DocumentsLoading>(),
        isA<DocumentsError>().having(
          (state) => state.message,
          'message',
          'Exception: Test error',
        ),
      ],
    );

    blocTest<DocumentsBloc, DocumentsState>(
      'emits [DocumentsLoading, DocumentsError] when upload fails',
      build: () {
        when(() => mockRepository.uploadDocument(any(), any()))
            .thenThrow(Exception('Upload failed'));
        return documentsBloc;
      },
      act: (bloc) => bloc.add(
        UploadDocument(
          type: 'ID_CARD',
          filePath: '/path/to/file.pdf',
        ),
      ),
      expect: () => [
        isA<DocumentsLoading>(),
        isA<DocumentsError>().having(
          (state) => state.message,
          'message',
          'Exception: Upload failed',
        ),
      ],
    );

    blocTest<DocumentsBloc, DocumentsState>(
      'emits [DocumentsLoading, DeleteSuccess] when DeleteDocument is added',
      build: () {
        when(() => mockRepository.deleteDocument(any()))
            .thenAnswer((_) async => true);
        return documentsBloc;
      },
      act: (bloc) => bloc.add(DeleteDocument('1')),
      expect: () => [
        isA<DocumentsLoading>(),
        isA<DeleteSuccess>(),
      ],
      verify: (_) {
        verify(() => mockRepository.deleteDocument('1')).called(1);
      },
    );

    blocTest<DocumentsBloc, DocumentsState>(
      'filters documents by status correctly',
      build: () {
        when(() => mockRepository.getDocuments())
            .thenAnswer((_) async => testDocuments);
        return documentsBloc;
      },
      act: (bloc) => bloc
        ..add(LoadDocuments())
        ..add(FilterDocuments('PENDING')),
      expect: () => [
        isA<DocumentsLoading>(),
        isA<DocumentsLoaded>()
            .having((state) => state.documents, 'documents', testDocuments),
        isA<DocumentsLoaded>().having(
          (state) => state.documents,
          'filtered documents',
          [testDocuments[0]],
        ),
      ],
    );
  });
}
