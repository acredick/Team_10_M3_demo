import 'package:flutter/material.dart';
import 'package:DormDash/widgets/dropoff_delivery_details_template.dart';

class DeliverOrder extends StatelessWidget {
  const DeliverOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deliver by 11:08 PM', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
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
            height: 380,
            width: double.infinity,
            child: Image.asset('assets/map_placeholder.png', fit: BoxFit.cover),
          ),
          Expanded(
            child: DeliveryDetailsCard(
              customerName: "Jeff",
              typeLabel: "Dropoff To",
              address: "1400 Washington Ave\nState Quad Cooper Hall\nAlbany, NY, 12222",
              itemCount: 2,
              onCallTap: () {},  //TODO: add later
              onDirectionsTap: () {}, // TODO: add later
              onSlideComplete: () async {
                Navigator.pushNamed(context, "/dropoff-confirmation");
              },
            ),
          )
        ],
      ),
    );
  }
}