import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_molkky_mobile/model/room.dart';
import 'package:my_molkky_mobile/model/player.dart';

class RoomDetailPage extends StatefulWidget {
  final String roomId;

  const RoomDetailPage({super.key, required this.roomId});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  String roomId = '';

  @override
  void initState() {
    super.initState();
    roomId = widget.roomId;
  }

  @override
  Widget build(BuildContext context) {
    buildRoomDetail() {
      final StreamController<Room> roomController = StreamController();
      final StreamController<List<Player>> playerController =
          StreamController();

      Stream<Room> getRoom() {
        final snapshots = FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .snapshots();
        snapshots.listen((snapshot) {
          final room = Room.fromFirestore(snapshot);
          roomController.add(room);
        });

        return roomController.stream;
      }

      Stream<List<Player>> getPlayers() {
        final snapshots = FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('players')
            .snapshots();
        snapshots.listen((snapshot) {
          final playerList = snapshot.docs.map((DocumentSnapshot doc) {
            return Player.fromFirestore(doc);
          }).toList();
          playerController.add(playerList);
        });

        return playerController.stream;
      }

      return StreamBuilder(
          stream: getPlayers(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Player>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
                children: snapshot.data!.map((player) {
              return Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                    title: Text(player.name),
                    subtitle: Text('★${player.stars}'),
                    minVerticalPadding: 20,
                    tileColor: Colors.white,
                    trailing: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: const Text('Join')),
                    leading: ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          player.iconImageUrl.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              );
            }).toList());
          });
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('players')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              alignment: FractionalOffset.center,
              child: const CircularProgressIndicator());
        } else {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Room'),
                centerTitle: true,
                backgroundColor: Colors.white,
              ),
              body: ListView(
                children: [
                  buildRoomDetail(),
                ],
              ));
        }
      },
    );
  }
}

class RoomPageArguments {
  String roomId = '';

  RoomPageArguments(this.roomId);
}
