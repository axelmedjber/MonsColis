import 'package:monscolis/core/network/api_client.dart';
import 'package:monscolis/core/network/network_info.dart';
import 'package:monscolis/core/storage/local_storage.dart';

class AppointmentsRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;

  AppointmentsRepository(this._apiClient, this._networkInfo);

  Future<List<Map<String, dynamic>>> getAppointments({
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final appointments = await _apiClient.getAppointments(
          status: status,
          fromDate: fromDate,
          toDate: toDate,
        );
        await LocalStorage.saveAppointments(appointments);
        return appointments;
      } catch (e) {
        return LocalStorage.getAppointments();
      }
    } else {
      return LocalStorage.getAppointments();
    }
  }

  Future<Map<String, dynamic>> createAppointment(
    String storeId,
    DateTime appointmentTime,
  ) async {
    if (await _networkInfo.isConnected) {
      final appointment = await _apiClient.createAppointment(
        storeId,
        appointmentTime,
      );
      
      final appointments = await LocalStorage.getAppointments();
      appointments.add(appointment);
      await LocalStorage.saveAppointments(appointments);
      
      return appointment;
    } else {
      throw Exception('Internet connection required to create appointment');
    }
  }

  Future<Map<String, dynamic>> cancelAppointment(String id) async {
    if (await _networkInfo.isConnected) {
      final appointment = await _apiClient.cancelAppointment(id);
      
      final appointments = await LocalStorage.getAppointments();
      final index = appointments.indexWhere((a) => a['id'] == id);
      if (index != -1) {
        appointments[index] = appointment;
        await LocalStorage.saveAppointments(appointments);
      }
      
      return appointment;
    } else {
      throw Exception('Internet connection required to cancel appointment');
    }
  }
}
