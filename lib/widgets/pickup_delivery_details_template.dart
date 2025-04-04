import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '/pages/shared/order_manager.dart';

class DeliveryDetailsCard extends StatelessWidget {
  final String typeLabel;
  final String title;     
  final String address;
  final String customerName;
  final int itemCount;
  final IconData primaryActionIcon;
  final VoidCallback? onCallTap;
  final VoidCallback? onDirectionsTap;
  final Future<void> Function()? onSlideComplete;
  final VoidCallback? onChatTap;

  const DeliveryDetailsCard({
    super.key,
    required this.typeLabel,
    required this.title,
    required this.address,
    required this.customerName,
    required this.itemCount,
    required this.onSlideComplete,
    this.primaryActionIcon = Icons.phone,
    this.onCallTap,
    this.onDirectionsTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF5B3184),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          _infoRow(typeLabel, title, primaryActionIcon),
          const SizedBox(height: 5),
          const Divider(color: Colors.white24, thickness: 1),

          const SizedBox(height: 5),
          _iconTextRow(Icons.restaurant, address, Icons.directions),
          const SizedBox(height: 5),
          const Divider(color: Colors.white24, thickness: 1),

          const SizedBox(height: 5),
          _iconTextRow(Icons.receipt_long, "$itemCount items", Icons.expand_more),
          const SizedBox(height: 5),
          const Divider(color: Colors.white24, thickness: 1),

          const SizedBox(height: 5),
          GestureDetector(
            onTap: onChatTap,
            child: _infoRow(typeLabel, customerName, Icons.message),
          ),
          const Divider(color: Colors.white24, thickness: 1),

          const SizedBox(height: 15),
        
          Builder(
            builder: (context) => SlideAction(
            text: "Slide After Arrival",
            textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14,),
            outerColor: Colors.white,
            innerColor: const Color.fromARGB(255, 0, 0, 0),
            elevation: 2,
            height: 50,
            sliderButtonIcon: const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Color.fromARGB(255, 255, 255, 255),
            ),

            onSubmit: onSlideComplete,
            ),
          ),
        ],
      ),
      ),   
    );
  }

  Widget _infoRow(String label, String title, IconData actionIcon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
        Icon(actionIcon, color: Colors.white),
      ],
    );
  }

  Widget _iconTextRow(IconData icon, String text, IconData trailing, {IconData? trailing2}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white))),
        Icon(trailing, color: Colors.white),
        if (trailing2 != null) ...[
          const SizedBox(width: 12),
          Icon(trailing2, color: Colors.white),
        ]
      ],
    );
  }
}