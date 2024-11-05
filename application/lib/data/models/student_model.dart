class Student {
  final String id;
  final String studentCode;
  final String fullName;
  final String gender;
  final DateTime birthDate;
  final String email;
  final String roomNumber;
  final String phoneNumber;
  final String address;
  final String? avatarUrl;

  Student({
    required this.id,
    required this.studentCode,
    required this.fullName,
    required this.email,
    required this.gender,
    required this.birthDate,
    required this.roomNumber,
    required this.phoneNumber,
    required this.address,
    required this.avatarUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      studentCode: json['studentCode'],
      fullName: json['fullname'],
      gender: json['gender'],
      birthDate: json['birthdate'],
      email: json['email'],
      roomNumber: json['roomNum'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentCode,
      'full_name': fullName,
      'gender': gender,
      'birthdate': birthDate,
      'email': email,
      'room_number': roomNumber,
      'phone_number': phoneNumber,
      'address': address,
      'avatar_url': avatarUrl,
    };
  }
}
