class ReturnModel {
  final String id;
  final String roomCode;
  final DateTime? returnDate;
  final DateTime? returnUpdateDate;
  final DateTime? returnCancelledDate;
  final String status;
  final String areaName;
  final double fee;

  ReturnModel({
    required this.id,
    required this.roomCode,
    required this.returnDate,
    required this.returnUpdateDate,
    required this.returnCancelledDate,
    required this.status,
    required this.areaName,
    required this.fee,
  });

  factory ReturnModel.fromJson(Map<String, dynamic> json) {
    return ReturnModel(
      id: json['ReturnID'],
      roomCode: json['RoomCode'],
      returnDate: json['ReturnDate'] != null
          ? DateTime.parse(json['ReturnDate'])
          : null,
      returnUpdateDate:
          json['UpdatedAt'] != null ? DateTime.parse(json['UpdatedAt']) : null,
      returnCancelledDate: json['CancelledAt'] != null
          ? DateTime.parse(json['CancelledAt'])
          : null,
      status: json['Status'],
      areaName: json['AreaName'],
      fee: double.parse(json['RoomFee']),
    );
  }
}
