import 'package:flutter/cupertino.dart';
import 'package:form_field_validator/form_field_validator.dart';
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
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Welcome to DormDash!',
              style: TextStyle(
                fontSize: 30,
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          validator: MultiValidator([
                            EmailValidator(
                              errorText: 'Please enter a valid email',
                            ),
                          ]).call,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              //color: Colors.green,
                            ),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(9.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          validator: MultiValidator([
                            MinLengthValidator(
                              0,
                              errorText: 'Please enter a password',
                            ),
                          ]).call,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.key, color: Colors.green),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(9.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Forgot password?', //todo replace route
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            child: Text(
                              'Login (temporarily bypassed)',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                              ),
                            ),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                print('form submiitted');
                              }
                              // todo replace route!
                              // temporary bypass
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                              );

                            },
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Center(
                            child: Text(
                              'Sign in using',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset(
                                    'assets/images/apple_logo.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset(
                                    'assets/images/google_logo.png',
                                    fit: BoxFit.fill,
                                  ),

                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0,),
                        child: Divider(color: Colors.grey,
                            height: 1.5,
                          ),
                        )
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                              children: [
                                Center(
                                  child: Text(
                                    'Don\'t have an account? ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    child: GestureDetector(
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.lightBlue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onTap: () {
                                        if (_formkey.currentState!.validate()) {
                                          print('form submiitted');
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const ConfirmStudentRoute(), // confirm student status
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

