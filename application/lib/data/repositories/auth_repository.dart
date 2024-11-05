import '../services/api_service.dart';
import '../models/student_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<Student> login(String studentCode, String password) async {
    try {
      final response = await _apiService.post('/auth/student/login', data: {
        'studentCode': studentCode,
        'password': password,
      });
      print("response");
      print(response);
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
