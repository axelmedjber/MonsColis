import 'package:monscolis/core/network/api_client.dart';
import 'package:monscolis/core/network/network_info.dart';
import 'package:monscolis/core/storage/local_storage.dart';

class DocumentsRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;

  DocumentsRepository(this._apiClient, this._networkInfo);

  Future<List<Map<String, dynamic>>> getDocuments() async {
    if (await _networkInfo.isConnected) {
      try {
        final documents = await _apiClient.getDocuments();
        await LocalStorage.saveDocuments(documents);
        return documents;
      } catch (e) {
        return LocalStorage.getDocuments();
      }
    } else {
      return LocalStorage.getDocuments();
    }
  }

  Future<Map<String, dynamic>> uploadDocument(
    String documentType,
    List<int> fileBytes,
    String fileName,
  ) async {
    if (await _networkInfo.isConnected) {
      final document = await _apiClient.uploadDocument(
        documentType,
        fileBytes,
        fileName,
      );
      
      final documents = await LocalStorage.getDocuments();
      documents.add(document);
      await LocalStorage.saveDocuments(documents);
      
      return document;
    } else {
      throw Exception('Internet connection required to upload document');
    }
  }

  Future<String> getDocumentUrl(String id) async {
    if (await _networkInfo.isConnected) {
      return _apiClient.getDocumentUrl(id);
    } else {
      throw Exception('Internet connection required to view document');
    }
  }
}
