import 'package:dio/dio.dart';

import '../services/api_service.dart';
import '../models/bill_model.dart';

class BillRepository {
  final ApiService _apiService;

  BillRepository(this._apiService);

  Future<List<Bill>> getBillsFromRoomId(String roomId) async {
    try {
      final response = await _apiService.get("/bills/room/$roomId");

      if (response.data['metadata'].isEmpty) {
        return [];
      }
      return (response.data['metadata'] as List)
          .map((e) => Bill.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> payBill(String billId) async {
    try {
      await _apiService.patch("/bills/$billId/pay");
    } catch (e) {
      rethrow;
    }
  }
}
