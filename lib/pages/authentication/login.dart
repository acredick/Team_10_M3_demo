import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth_platform_interface/src/providers/oauth.dart';
import 'package:flutter/material.dart';
import '../home.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Login')),
      child: Center(child: Login()),
    );
  }
}

class ConfirmStudentRoute extends StatelessWidget {
  const ConfirmStudentRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Second Route')),
      child: Center(
        child: Text('sign up page'),
        //_launchURL()
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();

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
                          {"tenant": "b5d22194-31d5-473f-9e1d-804fdcbd88ac"});

                      await FirebaseAuth.instance.signInWithProvider(provider);
                    },
                label: const Text("Sign in to your institution"),)
              )
            ]
        )
    );
  }
}

