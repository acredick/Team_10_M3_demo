import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/feedback_buttons.dart';
import '/pages/shared/review_manager.dart';
import '../shared/order_manager.dart';
import '../shared/status_manager.dart';
import '/pages/shared/user_util.dart';
import 'package:DormDash/pages/deliverer_side/dashboard.dart';


class DropoffConfirmation extends StatefulWidget {
  final String orderId;
  const DropoffConfirmation({super.key, required this.orderId});

  @override
  State<DropoffConfirmation> createState() => _DropoffConfirmationState();
}

class _DropoffConfirmationState extends State<DropoffConfirmation> {
  int _rating = 0;
  String _review = '';
  Map<String, dynamic>? orderData;
  String? customerName;
  double? orderPrice;
  String? restaurantName;
  String? address;
  int? itemCount;
  double? commissionRate = .3; // example commission
  String? customerID;
  Set<String> selectedFeedback = {};
  final List<String> feedbackOptions = [
    "On Time", "Friendly", "Respectful", "Unresponsive", "Clear Communication", "Rude"
  ];

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  void fetchOrderDetails() async {
    DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .get();

    if (orderSnapshot.exists) {
      setState(() {
        orderData = orderSnapshot.data() as Map<String, dynamic>;
        customerName = orderData!['customerFirstName'] ?? 'Unknown Customer';
        orderPrice = orderData!['price'] ?? 0.0;
        restaurantName = orderData!['restaurantName'] ?? 'Unknown Restaurant';
        itemCount = (orderData!['Items'] as List).length ?? 0;
        customerID = orderData!['customerID'] ?? "";
        address = orderData!['address'] ?? "Unknown Address";
      });
    }
  }

  static Widget _earningsRow(String label, String amount, {Color? color, bool bold = false}) {
    final style = TextStyle(
      color: color ?? Colors.grey,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(amount, style: style),
        ],
      ),
    );
  }

  // Image uploading
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orderData == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // prevents back button
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // prevents back button
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 150,
                      color: Colors.grey.shade300,
                      child: _selectedImage == null
                          ? const Center(
                        child: Icon(Icons.add, color: Colors.purple, size: 40),
                      )
                      // TODO: could maybe add crop functionality in the future?
                          : Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customerName ?? "Customer",
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      Text(address ?? "Unknown Address",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Earnings Breakdown",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              // Price Details Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _earningsRow("Base", "\$${(commissionRate! * orderPrice!).toStringAsFixed(2)}"),
                  // _earningsRow("Tip", "\$1.50"), // tip info will not be immediately available
                  _earningsRow("Total", "\$${(commissionRate! * orderPrice!).toStringAsFixed(2)}", color: Colors.black),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                  customerName != null
                      ? "How was your drop off with ${customerName}?"
                      : "How was your drop off today?",
                  style: TextStyle(fontSize: 18)
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              const Text("Leave a review (optional)", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _review = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your review...',
                ),
              ),
              const SizedBox(height: 20),
              FeedbackButtons(
                options: feedbackOptions,
                selected: selectedFeedback,
                onToggle: (label, selected) {
                  setState(() {
                    if (selected) {
                      selectedFeedback.add(label);
                    } else {
                      selectedFeedback.remove(label);
                    }
                  });
                },
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                    backgroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).colorScheme.primary),
                    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(vertical: 12)),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_rating != 0) {
                      ReviewManager.addRating(_rating, UserUtils.getEmail(), customerID!, true);
                    }
                    if (_review != "") {
                      ReviewManager.addReview(_review, UserUtils.getEmail(), customerID!, true);
                    }

                    OrderManager.setOrderID("-1"); // removes "active" order status
                    Navigator.pushNamed(context, "/dashboard");
                  },
                  child: Text('Delivered'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Center(
                  child: Text(
                    "Thank you for using DormDash!",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
