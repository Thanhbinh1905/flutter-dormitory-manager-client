import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import '../../../features/room/providers/room_provider.dart';
import 'package:intl/intl.dart';
import '../../../features/auth/providers/auth_provider.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final billProvider = Provider.of<BillProvider>(context, listen: false);

    final studentId = authProvider.currentUser?.id;
    if (roomProvider.currentRoom != null && studentId != null) {
      try {
        await roomProvider.getStudentRoom(studentId);
        await billProvider.getBillsFromRoom(roomProvider.currentRoom!.id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không thể tải hóa đơn: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);
    final billProvider = Provider.of<BillProvider>(context);
    // final currentRoom = roomProvider.currentRoom;
    if (billProvider.isLoading && roomProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (roomProvider.currentRoom == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Hóa đơn'),
        ),
        body: Center(
          child: Text('Bạn chưa có phòng'),
        ),
      );
    }

    final unpaidBills =
        billProvider.bills.where((bill) => !bill.isPaid).toList();
    final totalUnpaid = unpaidBills.fold<double>(
      0,
      (sum, bill) => sum + bill.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa đơn'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadBills,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng quan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        'Số hóa đơn chưa thanh toán:',
                        unpaidBills.length.toString(),
                      ),
                      _buildSummaryRow(
                        'Tổng tiền cần thanh toán:',
                        NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                            .format(totalUnpaid),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Danh sách hóa đơn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: billProvider.bills.length,
                itemBuilder: (context, index) {
                  final bill = billProvider.bills[index];
                  return Card(
                    child: ListTile(
                      title: Text('Hóa đơn tháng ${bill.month}/${bill.year}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Số tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(bill.amount)}',
                          ),
                          Text(
                            bill.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                            style: TextStyle(
                              color: bill.isPaid ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      trailing: bill.isPaid
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Xác nhận'),
                                      content: const Text(
                                          'Bạn có chắc chắn muốn thanh toán ?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Hủy'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: const Text('Xác nhận'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  await billProvider.payBill(
                                      bill.id); // Gọi phương thức hủy đăng ký
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Thanh toán thành công')),
                                  );
                                  // Refresh the screen after payment
                                  _loadBills();
                                }
                              },
                              child: const Text('Thanh toán'),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
