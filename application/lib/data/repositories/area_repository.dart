import '../services/api_service.dart';
import '../models/area_model.dart';

class AreaRepository {
  final ApiService _apiService;

  AreaRepository(this._apiService);

  Future<List<Area>> getAreas() async {
    try {
      final response = await _apiService.get('/areas');

      // print('API Response:');
      // print(response.data);

      if (response.data['metadata'] == null) {
        throw Exception('Invalid response format: metadata is null');
      }

      return (response.data['metadata'] as List)
          .map((area) => Area.fromJson(area))
          .toList();
    } catch (e) {
      print('Error in getAreas: $e');
      rethrow;
    }
  }
}
