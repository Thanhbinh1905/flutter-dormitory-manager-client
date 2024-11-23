import 'package:flutter/foundation.dart';
import '../../../data/repositories/return_repository.dart';
import '../../../data/models/return_model.dart';
import 'package:flutter/widgets.dart';

class ReturnProvider with ChangeNotifier {
  final ReturnRepository _returnRepository;
  ReturnModel? _currentReturn;
  bool _isLoading = false;
  String? _error;

  ReturnProvider(this._returnRepository);

  ReturnModel? get currentReturn => _currentReturn;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getStudentReturn(String studentId) async {
    try {
      _isLoading = true;
      _error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _currentReturn = await _returnRepository.getReturnByStudentId(studentId);

      if (_currentReturn == null) {
        _error = "Sinh viên không có yêu cầu trả phòng nào hiện tại.";
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

  Future<void> createReturn(String roomId, String studentId) async {
    try {
      _isLoading = true;
      _error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      await _returnRepository.createReturn(roomId, studentId);
      _currentReturn = await _returnRepository.getReturnByStudentId(studentId);

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

  Future<void> cancelReturn(String returnId) async {
    try {
      _isLoading = true;
      _error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      await _returnRepository.cancelReturn(returnId);
      _currentReturn = null;

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
    _currentReturn = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
