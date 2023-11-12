import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String id;
  final String hostId;
  final String name;
  final Timestamp createdAt;
  final bool delete;
  final List<dynamic> playerIds;
  // TODO: String型をやめる
  String status;

  Room({
    required this.id,
    required this.hostId,
    required this.name,
    required this.createdAt,
    required this.delete,
    required this.playerIds,
    required this.status,
  });

  factory Room.fromDocument(DocumentSnapshot document) {
    return Room(
      id: document.id,
      hostId: document['hostId'],
      name: document['name'],
      createdAt: document['createdAt'],
      delete: document['delete'],
      playerIds: document['playerIds'],
      status: document['status'],
    );
  }

  factory Room.fromFirestore(
    DocumentSnapshot snapshot,
  ) {
    final data = snapshot.data() as Map<dynamic, dynamic>;
    return Room(
      name: data['name'],
      hostId: data['hostId'],
      id: snapshot.id,
      createdAt: data['createdAt'],
      delete: data['delete'],
      playerIds: data['playerIds'],
      status: data['status'] as String,
    );
  }

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json['id'] as String,
        hostId: json['hostId'] as String,
        name: json['name'] as String,
        createdAt: json['createdAt'] as Timestamp,
        delete: json['delete'] as bool,
        playerIds: json['playerIds'] as List<dynamic>,
        status: json['status'] as String,
      );

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "hostId": hostId,
      "id": id,
      "createdAt": createdAt,
      "delete": delete,
      "playerIds": playerIds,
      "status": status,
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hostId': hostId,
        'name': name,
        'createdAt': createdAt,
        'delete': delete,
        'playerIds': playerIds,
        'status': status,
      };
}

enum RoomStatus {
  notStarted,
  firstHalfStarted,
  firstHalfFinished,
  secondHalfStarted,
  secondHalfFinished,
}

Map<RoomStatus, String> roomStatus = {
  RoomStatus.notStarted: 'NOT_STARTED',
  RoomStatus.firstHalfStarted: 'FIRST_HALF_STARTED',
  RoomStatus.firstHalfFinished: 'FIRST_HALF_FINISHED',
  RoomStatus.secondHalfStarted: 'SECOND_HALF_STARTED',
  RoomStatus.secondHalfFinished: 'SECOND_HALF_FINISHED',
};
