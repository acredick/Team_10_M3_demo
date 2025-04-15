import 'package:DormDash/pages/authentication/user_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/widgets/main_screen.dart';
import '../../widgets/user_util.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Login')),
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
    _signIn();
  }

  Future<void> _signIn() async {
    try {
      final provider = OAuthProvider("microsoft.com");
      provider.setCustomParameters(
          {"tenant": "b5d22194-31d5-473f-9e1d-804fdcbd88ac"});

      await FirebaseAuth.instance.signInWithProvider(provider);
      User? user = FirebaseAuth.instance.currentUser;
      UserUtils.saveSnapshot(user);

      if (user != null) {
        await redirect(user: user);
      }
    } catch (e) {
      print("Sign-in failed: $e");
    }
  }

  Future<void> redirect({required User user}) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserSelectionRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
