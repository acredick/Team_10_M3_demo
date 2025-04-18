import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/user_util.dart';

class DelivererSettingsPage extends StatefulWidget {
  @override
  _DelivererSettingsPageState createState() => _DelivererSettingsPageState();
}

class _DelivererSettingsPageState extends State<DelivererSettingsPage> {
  bool isDeliverer = true;

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Log Out"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/welcome");
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error logging out: $e")),
                );
              }
            },
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deliverer Settings"),
        automaticallyImplyLeading: false, // prevents back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),

            // toggle userType
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User Type: ${isDeliverer ? "Deliverer" : "Customer"}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: isDeliverer,
                  onChanged: (value) {
                    if (isDeliverer) {
                      setState(() {
                        isDeliverer = value;
                        UserUtils.setProfile("customer");
                        Navigator.pushNamed(context, "/customer-settings");
                        UserUtils.setUserType("customer");
                      });
                    } else {
                      setState(() {
                        isDeliverer = value;
                        UserUtils.setProfile("deliverer");
                        Navigator.pushNamed(context, "/deliverer-settings");
                        UserUtils.setUserType("deliverer");
                      });
                    }
                  },
                  activeColor: Color(0xFFDCB347),
                  inactiveTrackColor: Colors.purple,
                  inactiveThumbColor: Colors.purple[700],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout),
              label: Text("Log Out"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
