import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateDeliverer extends StatefulWidget {
  final String orderId; // Pass the orderId to fetch the correct order
  const RateDeliverer({super.key, required this.orderId});

  @override
  State<RateDeliverer> createState() => _RateDelivererState();
}

class _RateDelivererState extends State<RateDeliverer> {
  int _rating = 0;
  String _review = '';
  double? _selectedTip;
  TextEditingController _customTipController = TextEditingController();
  Map<String, dynamic>? orderData;
  String? dasherName;
  double? orderPrice;
  String? restaurantName;
  int? itemCount;
  double? taxRate = .08; //for new york
  double? fee = 4.99; // example fee
  bool _showCustomTipInput = false; // Flag to control visibility of custom tip input

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
        dasherName = orderData!['delivererFirstName'] ?? 'Unknown Dasher';
        orderPrice = orderData!['price'] ?? 0.0;
        restaurantName = orderData!['restaurantName'] ?? 'Unknown Restaurant';
        itemCount = (orderData!['Items'] as List).length ?? 0;
      });
    }
  }

  // Function to display price details in rows
  Widget _priceDetailRow(String label, String amount, {Color? color, bool bold = false}) {
    final style = TextStyle(
      color: color ?? Colors.grey[900],
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: style)),
          Text(amount, style: style),
        ],
      ),
    );
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
      body: SingleChildScrollView(  // Wrapping the entire body in a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and subtitle at the top
              const SizedBox(height: 20),
              Text(
                "Order Complete",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "$restaurantName - $itemCount ${itemCount == 1 ? 'item' : 'items'}",
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Text(
                  dasherName != null
                      ? "How was your drop off with ${dasherName}?"
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
              const SizedBox(height: 30),
              const Text("Leave a tip (optional)", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tip buttons (10%, 15%, 20%, Other)
                  _tipButton('10%', 0.10),
                  _tipButton('15%', 0.15),
                  _tipButton('20%', 0.20),
                ],
              ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTip = null; // Reset the selected tip when "Other" is clicked
                      _showCustomTipInput = true; // Show the custom tip input
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 30), // Ensure full width and similar height
                    backgroundColor: Colors.purple[700],
                  ),
                  child: Text(
                    "Other",
                    style: TextStyle(color: Colors.grey[200], fontSize: 14),
                  ),
                ),
              ),
              if (_showCustomTipInput)  // Show custom tip input only when _showCustomTipInput is true
                Column(
                  children: [
                    const SizedBox(height: 10),
                    TextField(
                      controller: _customTipController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your custom tip amount',
                      ),
                      onChanged: (value) {
                        // Automatically update the selected tip based on custom input
                        if (value.isNotEmpty) {
                          setState(() {
                            _selectedTip = double.tryParse(value);
                          });
                        }
                      },
                    ),
                  ],
                ),
              Divider(color: Colors.grey[500], thickness: 2),
              const SizedBox(height: 20),
              // Order Details section
              Text(
                "Order Details",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Price Details Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _priceDetailRow("DormDasher Tip", '\$${_selectedTip?.toStringAsFixed(2) ?? '0.00'}'),  // Fallback to '0.00' if _selectedTip is null
                  _priceDetailRow("DormDash Fee", '\$${fee?.toStringAsFixed(2) ?? '0.00'}'),  // Fallback to '0.00' if fee is null
                  _priceDetailRow("Subtotal", '\$${((_selectedTip ?? 0.0) + (fee ?? 0.0)).toStringAsFixed(2)}'),  // Handle null for _selectedTip and fee
                  _priceDetailRow("Taxes", '\$${(( (fee ?? 0.0)) * (taxRate ?? 0.08)).toStringAsFixed(2)}'),  // Default taxRate if null
                  _priceDetailRow("Total", '\$${((( (_selectedTip ?? 0.0) + (fee ?? 0.0)) * (1 + (taxRate ?? 0.08))).toStringAsFixed(2))}', bold: true),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the review and tip submission
                    double tipAmount = 0.0;
                    if (_selectedTip != null) {
                      tipAmount = _selectedTip!;
                    }

                    // Submit the review, rating, and tip (in real app, save this data to database)
                    // For now, we'll print them to the console
                    print('Rating: $_rating stars');
                    print('Review: $_review');
                    print('Tip: \$${tipAmount.toStringAsFixed(2)}');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40), // Ensure full width and similar height
                    backgroundColor: Colors.purple[700],
                  ),
                  child: Text('Submit Review & Tip',
                      style: TextStyle(color: Colors.grey[50])),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10), // Adjust padding as needed
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

  // Helper function to create each tip button
  Widget _tipButton(String label, double percentage) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedTip = (orderPrice! * percentage);
              _showCustomTipInput = false;  // Hide custom tip input if a predefined tip is selected
            });
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50), // Set the height of the button
            backgroundColor: Colors.purple[700], // Set background color to purple
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                style: TextStyle(color: Colors.grey[50]),),
              Text(
                '\$${(orderPrice! * percentage).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[200]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
