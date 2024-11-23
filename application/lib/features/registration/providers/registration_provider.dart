import 'package:flutter/foundation.dart';
import '../../../data/repositories/registration_repository.dart';
import '../../../data/models/registration_model.dart';
import 'package:flutter/widgets.dart';

class RegistrationProvider with ChangeNotifier {
  final RegistrationRepository _registrationRepository;
  RegistrationModel? _currentRegistration;
  bool _isLoading = false;
  String? _error;

  RegistrationProvider(this._registrationRepository);

  RegistrationModel? get currentRegistration => _currentRegistration;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getStudentRegistration(String studentId) async {
    try {
      _isLoading = true;
      _error = null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _currentRegistration =
          await _registrationRepository.getRegistrationsByStudentId(studentId);

      if (_currentRegistration == null) {
        _error = "Sinh viên không có đăng ký nào hiện tại.";
      }

      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      rethrow;
    }
  }

  Future<int> createRegistration(
      {required String roomId, required String studentId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final int status =
          await _registrationRepository.createRegistration(roomId, studentId);

      _isLoading = false;
      notifyListeners();

      return status;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> cancelRegistration(String registrationId) async {
    try {
      _isLoading = true;
      _error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      await _registrationRepository.cancelRegistration(registrationId);
      _currentRegistration = null;

      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      rethrow;
    }
  }

  void reset() {
    _currentRegistration = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
