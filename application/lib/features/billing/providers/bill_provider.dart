import '../../../data/repositories/bill_repository.dart';
import '../../../data/models/bill_model.dart';
import 'package:flutter/widgets.dart';

class BillProvider with ChangeNotifier {
  final BillRepository _billRepository;
  List<Bill> _bills = [];
  bool _isLoading = false;
  String? _error;

  BillProvider(this._billRepository);

  List<Bill> get bills => _bills;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getBillsFromRoom(String roomId) async {
    try {
      _isLoading = true;
      _error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      print('_bills');
      _bills = await _billRepository.getBillsFromRoomId(roomId);

      print(_bills);
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

  Future<void> payBill(String billId) async {
    try {
      _isLoading = true;
      _error = null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      await _billRepository.payBill(billId);

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
    _bills = [];
    _isLoading = false;
    _error = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
