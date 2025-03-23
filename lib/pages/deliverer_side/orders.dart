import 'package:flutter/material.dart';
import 'package:DormDash/widgets/delivery_details_template.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup by 10:58 PM', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Image.asset('assets/map_placeholder.png', fit: BoxFit.cover),
          ),
          Expanded(
            child: DeliveryDetailsCard(
              typeLabel: "Pickup From",
              title: "Baba’s Pizza",
              address: "1400 Washington Ave\nCampus Center\nAlbany, NY, 12222",
              customerName: "Jeff",
              itemCount: 2,
              onCallTap: () {},  //TODO: add later
              onDirectionsTap: () {}, // TODO: add later
            ),
          )
        ],
      ),
    );
  }
}