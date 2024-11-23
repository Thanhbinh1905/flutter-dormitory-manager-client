class Bill {
  final String id;
  final String roomId;
  final String month;
  final String year;
  final double amount;
  final bool isPaid;
  final DateTime createDate;
  final DateTime updateDate;

  Bill({
    required this.id,
    required this.roomId,
    required this.month,
    required this.year,
    required this.amount,
    required this.isPaid,
    required this.createDate,
    required this.updateDate,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['BillID'].toString(),
      roomId: json['RoomID'].toString(),
      month: json['MonthDate'].toString(),
      year: json['YearDate'].toString(),
      amount: double.parse(json['Amount']),
      isPaid: json['IsPaid'] == 1,
      createDate: DateTime.parse(json['CreatedAt']),
      updateDate: DateTime.parse(json['UpdatedAt']),
    );
  }
}
