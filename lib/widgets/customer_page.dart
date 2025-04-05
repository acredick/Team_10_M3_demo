import 'package:flutter/material.dart';
import 'package:DormDash/pages/shared/order_manager.dart';
import '/pages/customer_side/customer_chat.dart';
import 'package:DormDash/pages/shared/chat_manager.dart';
import '/widgets/bottom-nav-bar.dart';

class DeliveryDetailsCard extends StatelessWidget {
  final String typeLabel;
  final String title;
  final String address;
  final String customerName;
  final int itemCount;
  final String status;
  final double price;
  final IconData primaryActionIcon;
  final VoidCallback? onCallTap;
  final VoidCallback? onDirectionsTap;
  final VoidCallback? onChatTap;

  const DeliveryDetailsCard({
    super.key,
    required this.typeLabel,
    required this.title,
    required this.address,
    required this.customerName,
    required this.itemCount,
    required this.status,
    required this.price,
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
            GestureDetector(
              onTap: onChatTap,
              child: _infoRow(typeLabel, customerName, Icons.message),
            ),
            const Divider(color: Colors.white24, thickness: 1),

            const SizedBox(height: 5),
            _iconTextRow(Icons.delivery_dining, status),
            const SizedBox(height: 5),
            const Divider(color: Colors.white24, thickness: 1),

            const SizedBox(height: 5),
            _iconTextRow(Icons.home, address, Icons.directions),
            const SizedBox(height: 5),
            const Divider(color: Colors.white24, thickness: 1),

            const SizedBox(height: 5),
            _iconTextRow(
              Icons.receipt_long,
              "$itemCount ${itemCount == 1 ? 'item' : 'items'}",
              Icons.expand_more,
            ),
            const SizedBox(height: 5),
            const Divider(color: Colors.white24, thickness: 1),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String title, [IconData? actionIcon]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
        if (actionIcon != null) Icon(actionIcon, color: Colors.white),
      ],
    );
  }


  Widget _iconTextRow(IconData icon, String text, [IconData? trailing, IconData? trailing2]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        if (trailing != null) Icon(trailing, color: Colors.white),
        if (trailing != null && trailing2 != null) const SizedBox(width: 12),
        if (trailing2 != null) Icon(trailing2, color: Colors.white),
      ],
    );
  }
}
