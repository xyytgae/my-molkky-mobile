import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_molkky_mobile/model/room.dart';
import 'package:my_molkky_mobile/model/player.dart';
import 'package:my_molkky_mobile/model/util/color.dart';
import 'package:my_molkky_mobile/service/room.dart';
import 'package:my_molkky_mobile/service/player.dart';
import 'package:my_molkky_mobile/state/auth_state.dart';
import 'package:provider/provider.dart';
import 'package:my_molkky_mobile/main.dart';

class RoomDetailPage extends StatefulWidget {
  final String roomId;
  const RoomDetailPage({super.key, required this.roomId});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> with RouteAware {
  String roomId = '';

  final RoomRepo roomRepo = RoomRepo();
  final PlayerRepo playerRepo = PlayerRepo();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // この画面がpopされた際の処理
  @override
  void didPop() {
    final state = Provider.of<AuthState>(context, listen: false);
    if (state.loginedUser != null) {
      playerRepo.delete(roomId, state.loginedUser!.id);
    }
  }

  // この画面から新しい画面をpushした際の処理
  @override
  void didPushNext() {
    final state = Provider.of<AuthState>(context, listen: false);
    if (state.loginedUser != null) {
      playerRepo.delete(roomId, state.loginedUser!.id);
    }
  }

  @override
  void initState() {
    super.initState();
    roomId = widget.roomId;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AuthState>(context, listen: true);

    buildRoomDetail(Room? room) {
      final StreamController<List<Player>> playerController =
          StreamController();

      init() async {
        if (state.loginedUser != null &&
            room != null &&
            room.playerIds.length < 4) {
          await roomRepo.enterRoom(roomId, state.loginedUser!.id);
          await playerRepo.create(
              roomId,
              Player(
                  id: state.loginedUser!.id,
                  name: state.loginedUser!.name,
                  iconImageUrl: state.loginedUser!.iconImageUrl,
                  stars: state.loginedUser!.stars,
                  order: 0));
        }
      }

      init();

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

    return FutureBuilder(
      future: roomRepo.get(roomId),
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
                buildRoomDetail(snapshot.data),
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
