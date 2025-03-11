import 'package:flutter/material.dart';


class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5B3184), 
            body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Logo or Image
          Image.asset(
            'assets/images/DormDashLogo.png',  
            width: 1000,
            height: 400,
            fit: BoxFit.contain
          ),

          SizedBox(height: 100),

          

          // Get Started Button
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login'); // Navigate to login page
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color.fromARGB(255, 224, 181, 38),
            ),
            child: Text(
              "Get Started",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        

//for the dashboad page
ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard'); // Navigate to dashboard page
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color.fromARGB(255, 224, 181, 38),
            ),
            child: Text(
              "Dashboard",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],

      ),
    );
  }
}
