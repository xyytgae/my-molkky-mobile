import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_molkky_mobile/model/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_molkky_mobile/model/util/color.dart';
import 'package:my_molkky_mobile/ui/page/rooms/room_detail.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#f2e4cf'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 240.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'ログイン',
                  style: TextStyle(fontSize: 24.0, color: Colors.black),
                ),
                ElevatedButton(
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
                  child: Text('Googleログイン',
                      style: TextStyle(color: HexColor('#38512f'))),
                ),
              ],
            ),
          ),
        ));
  }
}
