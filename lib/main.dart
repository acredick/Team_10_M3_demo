import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pages/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import './widgets/main_screen.dart';
import '/pages/customer_side/customer-settings.dart';
import 'pages/customer_side/status.dart';
import '/widgets/bottom-nav-bar.dart';
import '/pages/customer_side/order_selection.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      routes: {
        "/login":
            (context) => Scaffold(
              body: Login(),
            ),
        "/customer-settings":
            (context) => Scaffold(
              body: CustomerSettingsPage(),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: 0,
                onItemTapped: (index) {},
                userType: "customer",
              ),
            ),
        "/customer-home":
            (context) => Scaffold(
              body: Status(),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: 0,
                onItemTapped: (index) {},
                userType: "customer",
              ),
            ),
        "/customer-order":
            (context) => Scaffold(
              body: OrderSelection(),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: 0,
                onItemTapped: (index) {},
                userType: "customer",
              ),
            ),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            final user = snapshot.data;
            return MainScreen(user: user);
          } else {
            return const LoginRoute();
          }
        },
      ),
    );
  }
}
