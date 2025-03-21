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
        '/': (context) => const WelcomePage(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginRoute(),
        '/dashboard': (context) => const DashboardPage(),
        "/customer-settings": (context) => Scaffold(
              body: const CustomerSettingsPage(),
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
              body: const OrderSelection(),
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
            return HomeScreen();
          } else {
            return const LoginRoute();
          }
        },
      ),
    );
  }
}
