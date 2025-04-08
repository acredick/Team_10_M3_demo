import 'package:DormDash/pages/deliverer_side/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:DormDash/widgets/feedback_buttons.dart';
import 'package:DormDash/widgets/star_rating.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DropoffConfirmation extends StatefulWidget {
  const DropoffConfirmation({super.key});

@override
  State<DropoffConfirmation> createState() => _DropoffConfirmationState();
}

class _DropoffConfirmationState extends State<DropoffConfirmation> {
  int _rating = 0;
  Set<String> selectedFeedback = {};
  final List<String> feedbackOptions = [
    "On Time", "Friendly", "Respectful", "Unresponsive", "Clear Communication", "Rude"
  ];


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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO: remove hard code
                    Text("Karissa M.", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    // TODO: remove hard code
                    Text("1400 Washington Ave", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    // TODO: remove hard code
                    Text("State Quad Cooper Hall"),
                    Text("Albany, NY, 12222"),
                  ],
            ),
          ],
         ),
         const SizedBox(height: 20),
            const Text("Earnings breakdown", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            // TODO: come up with fee system & remove hard coded numbers
            _earningsRow("Base", "\$3.00"),
            _earningsRow("Tip", "\$1.50"),
            _earningsRow("Total", "\$4.50", color: Colors.black),
            const SizedBox(height: 20),
            // TODO: replace hard code with customer name
            const Text("How was your drop off with Josh?", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StarRating(
                  rating: _rating,
                  onChanged: (newRating) {
                    setState(() {
                      _rating = newRating;
                    });
                  },
                ),
              ],
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
          const SizedBox(height: 20),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage()));
              },
              child: Text('Delivered'),
            ),
          )
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

  //Image uploading
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
}