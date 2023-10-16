import 'package:flutter/material.dart';
import 'package:my_molkky_mobile/ui/page/rooms.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Molkky',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const RoomsPage(title: 'Flutter Demo Home Page'),
    );
  }
}
