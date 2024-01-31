import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:my_molkky_mobile/ui/page/rooms.dart';
import 'package:my_molkky_mobile/ui/page/login.dart';
import 'package:my_molkky_mobile/ui/page/rooms/room_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_molkky_mobile/state/auth_state.dart';
import 'package:provider/provider.dart';

final databaseReference = FirebaseFirestore.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthState>(
            create: (_) => AuthState(),
          ),
        ],
        child: MaterialApp(
            title: 'My Molkky',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: const HomePage(title: 'My Molkky'),
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/room':
                  final args = settings.arguments as RoomPageArguments;
                  return MaterialPageRoute(
                    builder: (context) {
                      return RoomDetailPage(roomId: args.roomId);
                    },
                  );
                case '/rooms':
                  {
                    return MaterialPageRoute(
                      builder: (context) {
                        return const RoomsPage();
                      },
                    );
                  }
                case '/login':
                  {
                    return MaterialPageRoute(
                      builder: (context) {
                        return const LoginPage();
                      },
                    );
                  }
                default:
                  return null;
              }
            }));
    // ])
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          Container(color: Colors.white, child: const RoomsPage()),
        ],
      ),
    );
  }
}
