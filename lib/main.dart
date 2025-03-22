import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firebase_options.dart';

// Import pages
import 'pages/authentication/login.dart';
import 'pages/customer_side/customer-settings.dart';
import 'pages/customer_side/status.dart';
import 'widgets/bottom-nav-bar.dart';
import 'pages/customer_side/order_selection.dart';
import 'pages/ordering/dashboard.dart';
import 'pages/home.dart';
import 'pages/welcome.dart';
import '/pages/authentication/user_selection.dart';
import 'pages/ordering/orders.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => const LoginRoute(),
        '/dashboard': (context) => DashboardPage(),
        '/dashboard': (context) => DashboardPage(),
        '/orders': (context) => Scaffold(
            body: OrdersPage(),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: 1,
              onItemTapped: (index) {},
              userType: "deliverer",
              ),
            ),
        "/customer-settings": (context) => Scaffold(
              body: CustomerSettingsPage(),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: 0,
                onItemTapped: (index) {},
                userType: "customer",
              ),
            ),
        "/customer-home": (context) => Scaffold(
              body: const Status(),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: 0,
                onItemTapped: (index) {},
                userType: "customer",
              ),
            ),
        "/customer-order": (context) => Scaffold(
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
          if (snapshot.hasData) {
            return UserSelection();
          } else {
            return WelcomePage();
          }
        },
      ),
    );
  }
}
