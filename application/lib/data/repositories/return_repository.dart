import '../services/api_service.dart';
import '../models/return_model.dart';

class ReturnRepository {
  final ApiService _apiService;

  ReturnRepository(this._apiService);

  Future<ReturnModel?> getReturnByStudentId(String studentId) async {
    try {
      final response =
          await _apiService.get('/rooms/student/$studentId/return');
      if (response.data['metadata'].isEmpty) {
        return null;
      }
      return ReturnModel.fromJson(response.data['metadata'][0]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createReturn(String roomId, String studentId) async {
    try {
      await _apiService.post('/rooms/return', data: {
        'studentId': studentId,
        'roomId': roomId,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelReturn(String returnId) async {
    try {
      await _apiService.delete('/rooms/return/$returnId');
    } catch (e) {
      rethrow;
    }
  }
}
