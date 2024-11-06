import 'package:flutter/material.dart';

class RoomRegistrationScreen extends StatefulWidget {
  const RoomRegistrationScreen({super.key});

  @override
  State<RoomRegistrationScreen> createState() => _RoomRegistrationScreenState();
}

class _RoomRegistrationScreenState extends State<RoomRegistrationScreen> {
  String? _selectedBuilding;
  String? _selectedFloor;
  String? _selectedRoom;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
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
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tòa nhà',
                      ),
                      value: _selectedBuilding,
                      items: ['A1', 'A2', 'B1', 'B2'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('Tòa $value'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedBuilding = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tầng',
                      ),
                      value: _selectedFloor,
                      items: ['1', '2', '3', '4', '5'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('Tầng $value'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFloor = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Phòng',
                      ),
                      value: _selectedRoom,
                      items: ['101', '102', '103', '104'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('Phòng $value'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRoom = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Ngày bắt đầu'),
                      subtitle: Text(
                        _startDate?.toString().split(' ')[0] ?? 'Chọn ngày',
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
                            _startDate = date;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Ngày kết thúc'),
                      subtitle: Text(
                        _endDate?.toString().split(' ')[0] ?? 'Chọn ngày',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: _startDate ?? DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _endDate = date;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý đăng ký phòng
                },
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
