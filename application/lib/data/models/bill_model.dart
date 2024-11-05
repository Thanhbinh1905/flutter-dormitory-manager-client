class Bill {
  final String id;
  final String roomId;
  final String month;
  final int year;
  final double electricityAmount;
  final double waterAmount;
  final double roomFee;
  final double totalAmount;
  final bool isPaid;
  final DateTime dueDate;

  Bill({
    required this.id,
    required this.roomId,
    required this.month,
    required this.year,
    required this.electricityAmount,
    required this.waterAmount,
    required this.roomFee,
    required this.totalAmount,
    required this.isPaid,
    required this.dueDate,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      roomId: json['room_id'],
      month: json['month'],
      year: json['year'],
      electricityAmount: json['electricity_amount'].toDouble(),
      waterAmount: json['water_amount'].toDouble(),
      roomFee: json['room_fee'].toDouble(),
      totalAmount: json['total_amount'].toDouble(),
      isPaid: json['is_paid'],
      dueDate: DateTime.parse(json['due_date']),
    );
  }
}
