import 'package:monscolis/core/network/api_client.dart';
import 'package:monscolis/core/network/network_info.dart';
import 'package:monscolis/core/storage/local_storage.dart';

class StoresRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;

  StoresRepository(this._apiClient, this._networkInfo);

  Future<List<Map<String, dynamic>>> getStores() async {
    if (await _networkInfo.isConnected) {
      try {
        final stores = await _apiClient.getStores();
        await LocalStorage.saveStores(stores);
        return stores;
      } catch (e) {
        return LocalStorage.getStores();
      }
    } else {
      return LocalStorage.getStores();
    }
  }

  Future<Map<String, dynamic>?> getStore(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final store = await _apiClient.getStore(id);
        await LocalStorage.saveStore(id, store);
        return store;
      } catch (e) {
        return LocalStorage.getStore(id);
      }
    } else {
      return LocalStorage.getStore(id);
    }
  }

  Future<Map<String, dynamic>> getStoreAvailability(
    String id,
    DateTime date,
  ) async {
    // Availability always requires network connection
    if (await _networkInfo.isConnected) {
      return _apiClient.getStoreAvailability(id, date);
    } else {
      throw Exception('Internet connection required to check availability');
    }
  }
}
