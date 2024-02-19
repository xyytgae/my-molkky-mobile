import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_molkky_mobile/model/player.dart';
import 'package:flutter/material.dart';

class PlayerRepo {
  Future<void> create(String roomId, Player player) async {
    debugPrint('--------create player: ${player.id}--------');
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('players')
          .doc(player.id)
          .set(player.toFirestore());
    } catch (error) {
      debugPrint('error: $error');
    }
  }

  Future<void> delete(String roomId, String playerId) async {
    debugPrint('--------delete player: $playerId--------');
    debugPrint('--------from room: $roomId--------');
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('players')
          .doc(playerId)
          .delete();
    } catch (error) {
      debugPrint('error: $error');
    }
  }
}
