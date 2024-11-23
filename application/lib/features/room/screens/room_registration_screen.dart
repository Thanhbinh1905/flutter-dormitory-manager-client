import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/registration/providers/registration_provider.dart';
import '../../../features/return/providers/return_provider.dart';
import '../../../features/room/providers/area_provider.dart';
import '../../../data/models/return_model.dart';
import '../../../data/models/registration_model.dart';
import '../../../data/models/room_model.dart';
import 'package:intl/intl.dart';

class RoomRegistrationScreen extends StatefulWidget {
  const RoomRegistrationScreen({super.key});

  @override
  State<RoomRegistrationScreen> createState() => _RoomRegistrationScreenState();
}

class _RoomRegistrationScreenState extends State<RoomRegistrationScreen> {
  String? selectedAreaId;
  String? selectedRoomId;
  DateTime? startDate;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final registrationProvider =
        Provider.of<RegistrationProvider>(context, listen: false);
    final returnProvider = Provider.of<ReturnProvider>(context, listen: false);
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);

    final studentId = authProvider.currentUser?.id;

    if (studentId != null) {
      try {
        await Future.wait([
          roomProvider.getStudentRoom(studentId),
          returnProvider.getStudentReturn(studentId),
          areaProvider.getAreas(),
          registrationProvider.getStudentRegistration(studentId)
        ]);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không thể tải thông tin đăng ký: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);
    final registrationProvider = Provider.of<RegistrationProvider>(context);
    final returnProvider = Provider.of<ReturnProvider>(context);

    if (roomProvider.isLoading ||
        registrationProvider.isLoading ||
        returnProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // Có phòng
    if (roomProvider.currentRoom != null) {
      // Đã có đăng ký trả phòng
      if (returnProvider.currentReturn != null) {
        return _buildReturnInfoScreen(returnProvider.currentReturn!);
      }
      // Chưa đăng ký trả phòng
      return _buildReturnRegistrationScreen(roomProvider.currentRoom!);
    }

    // Chưa có phòng
    if (registrationProvider.currentRegistration != null) {
      // Đã có đăng ký phòng
      return _buildRegistrationInfoScreen(
          registrationProvider.currentRegistration!);
    }
    // Chưa đăng ký phòng
    return _buildRoomRegistrationScreen();
  }

  Widget _buildReturnInfoScreen(ReturnModel returnInfo) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin trả phòng')),
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
                    Text('Mã phòng: ${returnInfo.roomCode}'),
                    const SizedBox(height: 8),
                    Text(
                        'Ngày đăng ký trả: ${DateFormat('dd/MM/yyyy').format(returnInfo.returnDate!)}'),
                    const SizedBox(height: 8),
                    Text('Trạng thái: ${returnInfo.status}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Xử lý hủy đăng ký trả phòng
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text(
                            'Bạn có chắc chắn muốn hủy đăng ký trả phòng không?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Hủy'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text('Xác nhận'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    final returnProvider =
                        Provider.of<ReturnProvider>(context, listen: false);
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    final studentId = authProvider.currentUser?.id;
                    final roomId = returnProvider.currentReturn?.id;

                    if (studentId != null) {
                      await returnProvider
                          .cancelReturn(roomId!); // Gọi phương thức hủy đăng ký
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Hủy đăng ký trả phòng thành công')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Hủy đăng ký trả phòng'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnRegistrationScreen(Room room) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin phòng')),
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
                    Text('Mã phòng: ${room.roomCode}'),
                    const SizedBox(height: 8),
                    Text('Khu: ${room.areaName}'),
                    const SizedBox(height: 8),
                    Text(
                        'Giá phòng: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(room.fee)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Xác nhận trước khi đăng ký trả phòng
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text(
                            'Bạn có chắc chắn muốn đăng ký trả phòng không?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Hủy'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text('Xác nhận'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm == true) {
                    // Xử lý đăng ký trả phòng
                    final returnProvider =
                        Provider.of<ReturnProvider>(context, listen: false);

                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    final studentId = authProvider.currentUser?.id;
                    await returnProvider.createReturn(room.id,
                        studentId!); // Thay 'room' bằng tham số thích hợp
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Đăng ký trả phòng thành công')),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Đăng ký trả phòng'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationInfoScreen(RegistrationModel registration) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin đăng ký')),
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
                    Text('Mã phòng: ${registration.roomCode}'),
                    const SizedBox(height: 8),
                    Text(
                        'Ngày đăng ký: ${DateFormat('dd/MM/yyyy').format(registration.registrationDate!)}'),
                    const SizedBox(height: 8),
                    Text('Trạng thái: ${registration.status}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Xử lý hủy đăng ký trả phòng
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text(
                            'Bạn có chắc chắn muốn hủy đăng ký phòng không?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Hủy'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text('Xác nhận'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    final registrationProvider =
                        Provider.of<RegistrationProvider>(context,
                            listen: false);
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    final studentId = authProvider.currentUser?.id;
                    final roomId = registrationProvider.currentRegistration?.id;

                    if (studentId != null) {
                      await registrationProvider.cancelRegistration(
                          roomId!); // Gọi phương thức hủy đăng ký
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Hủy đăng ký trả phòng thành công')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Hủy đăng ký'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomRegistrationScreen() {
    final areaProvider = Provider.of<AreaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký phòng'),
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
                    if (areaProvider.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (areaProvider.error != null)
                      Center(child: Text('Lỗi: ${areaProvider.error}'))
                    else ...[
                      // Dropdown chọn khu
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Khu',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedAreaId,
                        items: areaProvider.areas.map((area) {
                          return DropdownMenuItem<String>(
                            value: area.id,
                            child: Text(area.areaName),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedAreaId = newValue;
                            // Reset selected room when area changes
                            selectedRoomId = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Dropdown chọn phòng
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Phòng',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedRoomId,
                        items: selectedAreaId != null
                            ? areaProvider
                                .getRoomsByArea(selectedAreaId!)
                                .where((room) => room.status == 'Available')
                                .map((room) {
                                return DropdownMenuItem<String>(
                                  value: room.id,
                                  child: Text(
                                      '${room.roomCode} - ${room.capacity} người - ${NumberFormat.currency(locale: 'vi_VN', symbol: 'tr').format(room.roomFee)}/tháng'),
                                );
                              }).toList()
                            : null,
                        onChanged: selectedAreaId == null
                            ? null
                            : (newValue) {
                                setState(() {
                                  selectedRoomId = newValue;
                                });
                              },
                      ),
                      const SizedBox(height: 16),

                      // Date pickers
                      ListTile(
                        title: const Text('Ngày bắt đầu'),
                        subtitle: Text(
                          startDate?.toString().split(' ')[0] ?? 'Chọn ngày',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              startDate = date;
                            });
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAreaId != null &&
                        selectedRoomId != null &&
                        startDate != null
                    ? () async {
                        final confirm = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Xác nhận"),
                                content:
                                    const Text("Tạo đơn đăng ký vào phòng ?"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Hủy")),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Xác nhận")),
                                ],
                              );
                            });

                        if (confirm == true) {
                          final registrationProvider =
                              Provider.of<RegistrationProvider>(context,
                                  listen: false);
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);

                          final studentId = authProvider.currentUser?.id;
                          try {
                            final status =
                                await registrationProvider.createRegistration(
                                    roomId: selectedRoomId!,
                                    studentId: studentId!);

                            String message;
                            if (status == 200) {
                              message = 'Đăng ký phòng thành công';
                            } else if (status == 203) {
                              message = 'Đăng ký thất bại: Phòng đã đầy';
                            } else {
                              message = 'Đăng ký thất bại: Lỗi không xác định';
                            }

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );

                              // Nếu đăng ký thành công, quay lại màn hình trước
                              if (status == 200) {
                                Navigator.of(context).pop();
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lỗi: ${e.toString()}')),
                              );
                            }
                          }
                        }
                      }
                    : null,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Đăng ký'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
