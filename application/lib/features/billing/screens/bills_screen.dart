import 'package:flutter/material.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa đơn'),
      ),
      body: SingleChildScrollView(
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
                    _buildSummaryRow('Số hóa đơn chưa thanh toán:', '2'),
                    _buildSummaryRow('Tổng tiền cần thanh toán:', '800,000đ'),
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
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Hóa đơn tháng ${12 - index}/2023'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Số tiền: ${400000 + index * 10000}đ'),
                        Text(
                          index < 2 ? 'Chưa thanh toán' : 'Đã thanh toán',
                          style: TextStyle(
                            color: index < 2 ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: index < 2
                        ? ElevatedButton(
                            onPressed: () {
                              // Xử lý thanh toán
                            },
                            child: const Text('Thanh toán'),
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                  ),
                );
              },
            ),
          ],
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
