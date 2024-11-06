class Room {
  final String id;
  final String roomCode;
  final int capacity;
  final String status;
  final double fee;
  final String areaName;
  final List<RoomStudent> students;

  Room({
    required this.id,
    required this.roomCode,
    required this.capacity,
    required this.status,
    required this.fee,
    required this.areaName,
    required this.students,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['RoomID'],
      roomCode: json['RoomCode'],
      capacity: json['Capacity'],
      status: json['RoomStatus'],
      fee: double.parse(json['RoomFee']),
      areaName: json['AreaName'],
      students: (json['students'] as List)
          .map((student) => RoomStudent.fromJson(student))
          .toList(),
    );
  }
}

class RoomStudent {
  final String studentId;
  final String fullName;
  final String studentCode;
  final String email;
  final String? phoneNumber;
  final String gender;
  final DateTime registrationDate;

  RoomStudent({
    required this.studentId,
    required this.fullName,
    required this.studentCode,
    required this.email,
    this.phoneNumber,
    required this.gender,
    required this.registrationDate,
  });

  factory RoomStudent.fromJson(Map<String, dynamic> json) {
    return RoomStudent(
      studentId: json['studentId'],
      fullName: json['fullName'],
      studentCode: json['studentCode'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      registrationDate: DateTime.parse(json['registrationDate']),
    );
  }
}
