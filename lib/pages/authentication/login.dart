import 'package:DormDash/pages/authentication/user_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/user_util.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('TEST TEST')),
      child: Center(child: Login()),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    print("Login screen initialized");
    _signIn();
  }

  Future<void> _signIn() async {
    print("Attempting sign-in...");
    try {
      final provider = OAuthProvider("microsoft.com");
      provider.setCustomParameters({
        "tenant": "b5d22194-31d5-473f-9e1d-804fdcbd88ac",
      });
      print("Provider set with custom parameters");

      await FirebaseAuth.instance.signInWithProvider(provider);
      print("Sign-in with provider successful");

      User? user = FirebaseAuth.instance.currentUser;
      print("User fetched: $user");

      if (user != null) {
        print("User is not null, redirecting...");
        await redirect(user: user);
      } else {
        print("User is null, unable to redirect");
      }
    } catch (e) {
      print("Sign-in failed: $e");
    }
  }

  Future<void> redirect({required User user}) async {
    print("Redirecting user...");
    UserUtils.saveSnapshot(user);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserSelectionRoute()),
      );
      print("Redirect successful");
    } else {
      print("Context is unmounted, unable to redirect");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
