import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class RoomInfoScreen extends StatefulWidget {
  const RoomInfoScreen({super.key});

  @override
  State<RoomInfoScreen> createState() => _RoomInfoScreenState();
}

class _RoomInfoScreenState extends State<RoomInfoScreen> {
  @override
  void initState() {
    super.initState();
    _loadRoomData();
  }

  Future<void> _loadRoomData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final studentId = authProvider.currentUser?.id;

    if (studentId != null) {
      try {
        await roomProvider.getStudentRoom(studentId);
      } catch (e) {
        if (mounted) {
          // print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không thể tải thông tin phòng: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);
    final currentRoom = roomProvider.currentRoom;

    if (roomProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Thông tin phòng'),
        ),
        body: roomProvider.currentRoom == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(roomProvider.error ?? ''),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/room-registration');
                      },
                      child: const Text('Chuyển sang đăng ký phòng'),
                    ),
                  ],
                ),
              )
            : roomProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadRoomData,
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
                                    'Phòng ${currentRoom?.roomCode ?? ""}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text('Thông tin cơ bản:'),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                      'Khu:', currentRoom?.areaName ?? ''),
                                  _buildInfoRow(
                                    'Sức chứa:',
                                    '${currentRoom?.capacity ?? 0} người',
                                  ),
                                  _buildInfoRow(
                                    'Giá phòng:',
                                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(currentRoom?.fee ?? 0)}/tháng',
                                  ),
                                  _buildInfoRow(
                                      'Trạng thái:', currentRoom?.status ?? ''),
                                ],
                              ),
                            ),
                          ),
                          if (currentRoom != null &&
                              currentRoom.students.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Danh sách thành viên',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: currentRoom.students.length,
                              itemBuilder: (context, index) {
                                final student = currentRoom.students[index];
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        student.fullName
                                            .substring(0, 1)
                                            .toUpperCase(),
                                      ),
                                    ),
                                    title: Text(student.fullName),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('MSSV: ${student.studentCode}'),
                                        if (student.phoneNumber != null)
                                          Text('SĐT: ${student.phoneNumber}'),
                                        Text(
                                          'Ngày đăng ký: ${DateFormat('dd/MM/yyyy').format(student.registrationDate)}',
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
