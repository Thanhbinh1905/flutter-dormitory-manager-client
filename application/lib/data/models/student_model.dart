class Student {
  final String id;
  final String studentCode;
  final String fullName;
  final String? gender;
  final DateTime? birthDate;
  final String email;
  final String? roomNumber;
  final String? phoneNumber;
  final String? address;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Student({
    required this.id,
    required this.studentCode,
    required this.fullName,
    required this.email,
    this.gender,
    this.birthDate,
    this.roomNumber,
    this.phoneNumber,
    this.address,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['StudentID'] as String,
      studentCode: json['StudentCode'] as String,
      fullName: json['FullName'] as String,
      gender: json['Gender'] as String?,
      birthDate: json['BirthDate'] != null
          ? DateTime.tryParse(json['BirthDate'] as String)
          : null,
      email: json['Email'] as String,
      roomNumber: json['RoomNumber'] as String?,
      phoneNumber: json['PhoneNumber'] as String?,
      address: json['Address'] as String?,
      avatarUrl: json['Avatar'] as String?,
      createdAt: json['CreatedAt'] != null
          ? DateTime.tryParse(json['CreatedAt'] as String)
          : null,
      updatedAt: json['UpdatedAt'] != null
          ? DateTime.tryParse(json['UpdatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StudentID': id,
      'StudentCode': studentCode,
      'FullName': fullName,
      'Gender': gender,
      'BirthDate': birthDate?.toIso8601String(),
      'Email': email,
      'RoomNumber': roomNumber,
      'PhoneNumber': phoneNumber,
      'Address': address,
      'Avatar': avatarUrl,
      'CreatedAt': createdAt?.toIso8601String(),
      'UpdatedAt': updatedAt?.toIso8601String(),
    };
  }
}
