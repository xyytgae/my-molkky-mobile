import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_molkky_mobile/model/room.dart';
import 'package:flutter/material.dart';

class RoomRepo {
  Future<Room?> get(String roomId) async {
    debugPrint('--------get room: $roomId--------');
    try {
      final DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .get();
      if (roomSnapshot.exists) {
        return Room.fromFirestore(roomSnapshot);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('error: $error');
      return null;
    }
  }

  Future<void> enterRoom(String roomId, String playerId) async {
    debugPrint('--------enter room: $roomId--------');
    debugPrint('--------playerId: $playerId--------');
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
        'playerIds': FieldValue.arrayUnion([playerId])
      });
    } catch (error) {
      debugPrint('error: $error');
    }
  }
}
