import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              // Xử lý đánh dấu tất cả là đã đọc
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Số lượng thông báo giả định
        itemBuilder: (context, index) {
          final bool isUnread = index < 3; // 3 thông báo đầu chưa đọc
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getNotificationColor(index),
                child: _getNotificationIcon(index),
              ),
              title: Text(
                _getNotificationTitle(index),
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_getNotificationContent(index)),
                  const SizedBox(height: 4),
                  Text(
                    '2 giờ trước',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: isUnread
                  ? Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
              onTap: () {
                // Xử lý khi nhấn vào thông báo
              },
            ),
          );
        },
      ),
    );
  }

  Color _getNotificationColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red[100]!;
      case 1:
        return Colors.green[100]!;
      case 2:
        return Colors.blue[100]!;
      default:
        return Colors.orange[100]!;
    }
  }

  Icon _getNotificationIcon(int index) {
    switch (index % 4) {
      case 0:
        return const Icon(Icons.warning, color: Colors.red);
      case 1:
        return const Icon(Icons.check_circle, color: Colors.green);
      case 2:
        return const Icon(Icons.info, color: Colors.blue);
      default:
        return const Icon(Icons.notifications, color: Colors.orange);
    }
  }

  String _getNotificationTitle(int index) {
    switch (index % 4) {
      case 0:
        return 'Thông báo khẩn';
      case 1:
        return 'Thanh toán thành công';
      case 2:
        return 'Thông tin mới';
      default:
        return 'Thông báo chung';
    }
  }

  String _getNotificationContent(int index) {
    switch (index % 4) {
      case 0:
        return 'Có sự cố cần xử lý tại phòng của bạn';
      case 1:
        return 'Hóa đơn tháng này đã được thanh toán';
      case 2:
        return 'Có thông tin cập nhật về nội quy KTX';
      default:
        return 'Thông báo chung về hoạt động KTX';
    }
  }
}
