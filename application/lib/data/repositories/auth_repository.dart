import '../services/api_service.dart';
import '../models/student_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<Student> login(String studentId, String password) async {
    try {
      final response = await _apiService.post('/auth/login', data: {
        'student_id': studentId,
        'password': password,
      });

      return Student.fromJson(response.data['user']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
    } catch (e) {
      rethrow;
    }
  }
}
