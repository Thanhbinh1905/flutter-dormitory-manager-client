import '../services/api_service.dart';
import '../models/room_model.dart';

class RoomRepository {
  final ApiService _apiService;

  RoomRepository(this._apiService);

  Future<Room?> getStudentRoom(String studentId) async {
    try {
      final response = await _apiService.get('/rooms/student/$studentId/room');

      // Kiểm tra mã trạng thái và thông điệp
      if (response.data['status'] == 202) {
        return null; // Trả về null nếu sinh viên không có phòng
      }

      return Room.fromJson(response.data['metadata']);
    } catch (e) {
      rethrow;
    }
  }
}
