import 'package:flutter/foundation.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/student_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  Student? _currentUser;
  bool _isLoading = false;

  AuthProvider(this._authRepository);

  Student? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> login(String studentCode, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentUser = await _authRepository.login(studentCode, password);

      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
