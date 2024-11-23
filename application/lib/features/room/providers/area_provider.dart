import '../../../data/repositories/area_repository.dart';
import '../../../data/models/area_model.dart';
import 'package:flutter/widgets.dart';

class AreaProvider with ChangeNotifier {
  final AreaRepository _areaRepository;
  List<Area> _areas = [];
  bool _isLoading = false;
  String? _error;

  AreaProvider(this._areaRepository);

  List<Area> get areas => _areas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getAreas() async {
    try {
      _isLoading = true;
      _error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _areas = await _areaRepository.getAreas();

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
    _areas = [];
    _isLoading = false;
    _error = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Helper methods
  List<AreaRoom> getAvailableRooms() {
    return _areas
        .expand((area) => area.rooms)
        .where((room) => room.status == 'Available')
        .toList();
  }

  List<AreaRoom> getRoomsByArea(String areaId) {
    final area = _areas.firstWhere((area) => area.id == areaId);
    return area.rooms;
  }

  List<AreaRoom> getRoomsByStatus(String status) {
    return _areas
        .expand((area) => area.rooms)
        .where((room) => room.status == status)
        .toList();
  }
}
