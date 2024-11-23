import 'package:application/main.dart';
import 'package:flutter/foundation.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/student_model.dart';
import 'package:provider/provider.dart';
import '../../../features/room/providers/room_provider.dart';
import '../../../features/registration/providers/registration_provider.dart';
import '../../../features/return/providers/return_provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  Student? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authRepository);

  Student? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
      _isLoading = false;
      _error = null;

      // Reset các provider khác
      final context = navigatorKey.currentContext!;
      Provider.of<RoomProvider>(context, listen: false).reset();
      Provider.of<RegistrationProvider>(context, listen: false).reset();
      Provider.of<ReturnProvider>(context, listen: false).reset();

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
