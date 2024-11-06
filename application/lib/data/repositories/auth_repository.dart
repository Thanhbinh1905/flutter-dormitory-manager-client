import '../services/api_service.dart';
import '../models/student_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  AuthRepository(this._apiService, this._prefs);

  Future<Student> login(String studentCode, String password) async {
    try {
      final response = await _apiService.post('/auth/student/login', data: {
        'studentCode': studentCode,
        'password': password,
      });
      final loginToken = response.data['metadata']['token'];

      await _prefs.setString('token', loginToken);
      return Student.fromJson(response.data['metadata']['student']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/student/logout');
    } catch (e) {
      rethrow;
    }
  }
}
