class RegistrationModel {
  final String id;
  final String roomCode;
  final DateTime? registrationDate;
  final DateTime? registrationUpdateDate;
  final DateTime? registrationCancelledDate;
  final String status;
  final String areaName;
  final double fee;

  RegistrationModel(
      {required this.id,
      required this.roomCode,
      required this.registrationDate,
      required this.registrationUpdateDate,
      required this.registrationCancelledDate,
      required this.status,
      required this.areaName,
      required this.fee});

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
        id: json['RegistrationID'],
        roomCode: json['RoomCode'],
        registrationDate: json['RegistrationDate'] != null
            ? DateTime.parse(json['RegistrationDate'])
            : null,
        registrationUpdateDate: json['UpdatedAt'] != null
            ? DateTime.parse(json['UpdatedAt'])
            : null,
        registrationCancelledDate: json['CancelledAt'] != null
            ? DateTime.parse(json['CancelledAt'])
            : null,
        status: json['Status'],
        areaName: json['AreaName'],
        fee: double.parse(json['RoomFee']));
  }
}
