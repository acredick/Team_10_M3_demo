import 'package:flutter/material.dart';

class RateDeliverer extends StatefulWidget {
  const RateDeliverer({super.key});

  @override
  State<RateDeliverer> createState() => _RateDelivererState();
}

class _RateDelivererState extends State<RateDeliverer> {
  int _rating = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Dropoff"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 120,
                  height: 150,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.purple, size: 40),
                  ),
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Karissa M.", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    Text("1400 Washington Ave", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text("State Quad Cooper Hall"),
                    Text("Albany, NY, 12222"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Earnings breakdown", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            _earningsRow("Base", "\$3.00"),
            _earningsRow("Tip", "\$1.50"),
            _earningsRow("Total", "\$4.50", color: Colors.black),
            const SizedBox(height: 30),
            const Text("How was your drop off with Josh?", style: TextStyle(fontSize: 18)),
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
            //TODO: Feedback & delivered button
          ],
        ),
      ),
    );
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
}