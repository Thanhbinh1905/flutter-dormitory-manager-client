class Area {
  final String id;
  final String areaName;
  final List<AreaRoom> rooms;

  Area({
    required this.id,
    required this.areaName,
    required this.rooms,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['AreaID'],
      areaName: json['AreaName'],
      rooms: (json['Rooms'] as List)
          .map((room) => AreaRoom.fromJson(room))
          .toList(),
    );
  }
}

class AreaRoom {
  final String id;
  final String roomCode;
  final int capacity;
  final String status;
  final double roomFee;

  AreaRoom({
    required this.id,
    required this.roomCode,
    required this.capacity,
    required this.status,
    required this.roomFee,
  });

  factory AreaRoom.fromJson(Map<String, dynamic> json) {
    return AreaRoom(
      id: json['RoomID'],
      roomCode: json['RoomCode'],
      capacity: json['Capacity'],
      status: json['Status'],
      roomFee: double.parse(json['RoomFee']),
    );
  }
}
