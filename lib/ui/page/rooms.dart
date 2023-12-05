import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_molkky_mobile/model/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_molkky_mobile/model/util/color.dart';
import 'package:my_molkky_mobile/ui/page/rooms/room_detail.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  @override
  Widget build(BuildContext context) {
    buildRoomList() {
      final StreamController<List<Room>> allRoomsController =
          StreamController();

      Stream<List<Room>> getRooms() {
        final snapshots =
            FirebaseFirestore.instance.collection('rooms').snapshots();
        snapshots.listen((snapshot) {
          final roomList = snapshot.docs.map((DocumentSnapshot doc) {
            return Room.fromFirestore(doc);
          }).toList();
          allRoomsController.add(roomList);
        });

        return allRoomsController.stream;
      }

      return StreamBuilder(
          stream: getRooms(),
          builder: (BuildContext context, AsyncSnapshot<List<Room>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return Column(
                  children: snapshot.data!.map((room) {
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: ListTile(
                      title: Text(room.name),
                      minVerticalPadding: 20,
                      tileColor: HexColor('#fef5e7'),
                      trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/room',
                                arguments: RoomPageArguments(room.id));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#38512f'),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('入室'))),
                );
              }).toList());
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          });
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                alignment: FractionalOffset.center,
                child: const CircularProgressIndicator());
          } else {
            return Scaffold(
                backgroundColor: HexColor('#f2e4cf'),
                appBar: AppBar(
                  // leading: IconButton(
                  //   icon: const Icon(Icons.menu),
                  //   onPressed: () {
                  //     Scaffold.of(context).openDrawer();
                  //   },
                  // ),

                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                              color: HexColor('#38512f'),
                              width: 1,
                              style: BorderStyle.solid),
                        ),
                        child: Text('ログイン',
                            style: TextStyle(color: HexColor('#38512f'))),
                      ),
                    ),
                  ],
                  backgroundColor: Colors.white,
                  // title: const Text('My Molkky'),
                ),
                body: ListView(
                  children: [
                    buildRoomList(),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  fixedColor: HexColor('#38512f'),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'ホーム',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add),
                      label: 'ルーム作成',
                    ),
                  ],
                  currentIndex: 0,
                  onTap: (int index) {
                    switch (index) {
                      case 0:
                        Navigator.pushNamed(context, '/home');
                        break;
                      case 1:
                        Navigator.pushNamed(context, '/create_room');
                        break;
                    }
                  },
                ));
          }
        });
  }
}
