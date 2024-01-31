import 'package:flutter/material.dart';
import 'package:my_molkky_mobile/model/util/color.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:my_molkky_mobile/state/auth_state.dart';
import 'package:provider/provider.dart';

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
          child: Card(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Text(
                        'ログイン',
                        style: TextStyle(
                            fontSize: 24.0,
                            color: HexColor('#38512f'),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 50),
                    SignInButton(
                        buttonType: ButtonType.google,
                        onPressed: () async {
                          final state =
                              Provider.of<AuthState>(context, listen: false);
                          state.googleLogin().then((_) {
                            if (state.loginedUser != null) {
                              Navigator.pushNamed(context, '/rooms');
                            }
                          });
                        }),
                    const SizedBox(height: 50),
                  ],
                ),
              )),
        ));
  }
}
