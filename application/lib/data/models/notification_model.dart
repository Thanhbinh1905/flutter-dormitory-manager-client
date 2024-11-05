class Notification {
  final String id;
  final String senderId;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String type;

  Notification({
    required this.id,
    required this.senderId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isRead,
    required this.type,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      senderId: json['senderId'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'],
      type: json['type'],
    );
  }
}
