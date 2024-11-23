import '../../../data/repositories/room_repository.dart';
import '../../../data/models/room_model.dart';
import 'package:flutter/widgets.dart';

class RoomProvider with ChangeNotifier {
  final RoomRepository _roomRepository;
  Room? _currentRoom;
  bool _isLoading = false;
  String? _error;

  RoomProvider(this._roomRepository);

  Room? get currentRoom => _currentRoom;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getStudentRoom(String studentId) async {
    try {
      _isLoading = true;
      _error = null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _currentRoom = await _roomRepository.getStudentRoom(studentId);

      if (_currentRoom == null) {
        _error = "Sinh viên không có phòng nào hiện tại.";
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

  void reset() {
    _currentRoom = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
