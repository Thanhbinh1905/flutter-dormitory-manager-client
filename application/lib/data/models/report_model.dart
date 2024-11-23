class ReportModel {
  final String reportId;
  final String senderId;
  final String title;
  final String content;
  final DateTime? createTime;
  final String status;
  ReportModel({
    required this.reportId,
    required this.senderId,
    required this.title,
    required this.content,
    required this.createTime,
    required this.status,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['ReportID'],
      senderId: json['SenderID'],
      title: json['Title'],
      content: json['Content'],
      createTime: DateTime.parse(json['CreatedAt']),
      status: json['Status'],
    );
  }
}
