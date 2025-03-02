/* import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, title = "DormDash Login"});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bool _isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton.icon(
                onPressed: () async {
                  final provider = OAuthProvider("microsoft.com");
                  provider.setCustomParameters(
                      {"tenant": "b5d22194-31d5-473f-9e1d-804fdcbd88ac"},
                  );
                  await FirebaseAuth.instance.signInWithProvider(provider);
                },
                label: const Text("Sign in to your institution"),
            )
          )
        ]
      )
    );
  }
} */
//////////////////////////////////////////////////

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/model/failure.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _microsoftSignIn = AadOAuth(Config(
    // If you dont have a special tenant id, use "common"
    tenant: "common",
    clientId: "9a729ad5-27da-4c69-a053-328444f08b82",
    // Replace this with your client id ("Application (client) ID" in the Azure Portal)
    responseType: "code",
    scope: "User.Read",
    redirectUri: "https://dormdash-v2.firebaseapp.com/__/auth/handler",
    loader: const Center(child: CircularProgressIndicator()),
    navigatorKey: navigatorKey,
  ));

  _loginWithMicrosoft() async {
    var result = await _microsoftSignIn.login();

    result.fold(
          (Failure failure) {
        // Auth failed, show error
      },
          (Token token) async {
        if (token.accessToken == null) {
          // Handle missing access token, show error or whatever
          return;
        }

        // Handle successful login
        print('Logged in successfully, your access token: ${token.accessToken!}');

        // Perform necessary actions with the access token, such as API calls or storing it securely.

        await _microsoftSignIn.logout();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _loginWithMicrosoft(),
        child: Text('Log in with Microsoft'),
      ),
    );
  }
}



