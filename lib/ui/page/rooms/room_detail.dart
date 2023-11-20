import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_molkky_mobile/model/room.dart';
import 'package:my_molkky_mobile/model/player.dart';
import 'package:my_molkky_mobile/model/util/color.dart';

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
          final players = snapshot.docs.map((DocumentSnapshot doc) {
            return Player.fromFirestore(doc);
          }).toList();
          playerController.add(players);
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
                    subtitle: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                          text: '★',
                          style: TextStyle(
                            color: HexColor('#ffa000'),
                          ),
                        ),
                        TextSpan(
                          text: player.stars.toString(),
                        ),
                      ],
                    )),
                    minVerticalPadding: 20,
                    tileColor: HexColor('#fef5e7'),
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
            backgroundColor: HexColor('#f2e4cf'),
            appBar: AppBar(
              title: const Text('Room'),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                buildRoomDetail(),
                Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 50),
                        backgroundColor: HexColor('#38512f'),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('START'),
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}

class RoomPageArguments {
  String roomId = '';

  RoomPageArguments(this.roomId);
}
