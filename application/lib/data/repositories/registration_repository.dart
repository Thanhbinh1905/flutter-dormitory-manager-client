import '../services/api_service.dart';
import '../models/registration_model.dart';

class RegistrationRepository {
  final ApiService _apiService;

  RegistrationRepository(this._apiService);

  Future<RegistrationModel?> getRegistrationsByStudentId(
      String studentId) async {
    try {
      final response =
          await _apiService.get('/rooms/student/$studentId/registration');
      if (response.data['metadata'].isEmpty) {
        return null;
      }
      return RegistrationModel.fromJson(response.data['metadata'][0]);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> createRegistration(String roomId, String studentId) async {
    try {
      final response = await _apiService.post('/rooms/registration', data: {
        'studentId': studentId,
        'roomId': roomId,
      });
      return response.data['status'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelRegistration(String registrationId) async {
    try {
      await _apiService.delete('/rooms/registration/$registrationId');
    } catch (e) {
      rethrow;
    }
  }
}
