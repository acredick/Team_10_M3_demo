import 'package:DormDash/pages/deliverer_side/dropoff-confirmaton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firebase_options.dart';
import 'package:DormDash/pages/customer_side/status.dart'; 


// Import pages
import 'pages/authentication/login.dart';
import 'pages/customer_side/customer-settings.dart';
import 'pages/customer_side/status.dart';
import 'widgets/bottom-nav-bar.dart';
import 'pages/customer_side/order_selection.dart';
import 'pages/deliverer_side/dashboard.dart';
import 'pages/home.dart';
import 'pages/welcome.dart';
import '/pages/authentication/user_selection.dart';
import 'pages/deliverer_side/pickup_order.dart';
import 'pages/deliverer_side/deliver_order.dart';
import 'pages/deliverer_side/deliverer_settings.dart';

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
        colorScheme: 
          ColorScheme.fromSeed(
            seedColor: Color (0xFF5B3184),
            primary: Color(0xFF5B3184),
            secondary: Color(0xFFEEB111),
            error: Colors.red,
            tertiary: Color (0xFF4CAF50), // previously "success"
            ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => const LoginRoute(),
        '/dashboard': (context) => DashboardPage(),
        '/orders': (context) => Scaffold(
            body: OrdersPage(orderId: ''),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: 1,
              onItemTapped: (index) {},
              userType: "deliverer",
              ),
            ),
        '/deliver-order' : (context) => Scaffold(
            body: DeliverOrder(),
            bottomNavigationBar: CustomBottomNavigationBar (
              selectedIndex: 1,
              onItemTapped: (index) {},
              userType: "deliverer",
            ),
          ),
          '/dropoff-confirmation' : (context) => Scaffold(
            body: DropoffConfirmation(),
            bottomNavigationBar: CustomBottomNavigationBar (
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
        "/customer-home": (context){
          return Scaffold(
              body: Status(orderID: 'order1'),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: 0,
                onItemTapped: (index) {},
                userType: "customer",
              ),
            );
        },
        "/customer-order": (context) => Scaffold(
              body: OrderSelection(),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: 0,
                onItemTapped: (index) {},
                userType: "customer",
              ),
            ),
          
        "/deliverer-settings": (context) => Scaffold(
          body: DelivererSettingsPage(),
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: 0,
            onItemTapped: (index) {},
            userType: "deliverer",
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