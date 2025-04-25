import 'package:flutter/material.dart';
import '../../widgets/order_manager.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/user_util.dart';
import '../../widgets/chat_manager.dart';
import '../../widgets/status_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class EnterAddressPage extends StatefulWidget {
  final String orderID;

  EnterAddressPage({required this.orderID});

  @override
  _EnterAddressPageState createState() => _EnterAddressPageState();
}

class _EnterAddressPageState extends State<EnterAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  static final Uuid _uuid = Uuid();
  String orderID = _uuid.v4();  // Generate a random order ID
  List<String> _addressSuggestions = [];
  Timer? _debounce;
  bool _isAddressSelectedFromSuggestions = false;

  Future<void> _submitAddress() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Address cannot be empty")));
      return;
    }

    if (!_isAddressSelectedFromSuggestions) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a valid address from suggestions")));
      return;
    }

    OrderManager.clearDelivererInfo(widget.orderID); // used for local testing purposes
    OrderManager.updateOrder(widget.orderID, "orderID", widget.orderID);
    OrderManager.updateOrder(widget.orderID, "address", _addressController.text);
    OrderManager.updateOrder(widget.orderID, "customerID", UserUtils.getEmail());
    OrderManager.updateOrder(widget.orderID, "customerFirstName", UserUtils.getFirstName());
    OrderManager.updateOrder(widget.orderID, "customerLastName", UserUtils.getLastName());
    OrderManager.setOrderID(widget.orderID);
    StatusManager.initializeStatus();

    ChatManager.generateChatID();
    ChatManager.openChat();
    OrderManager.updateOrder(widget.orderID, "chatID", ChatManager.getRecentChatID());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order updated for delivery!")));
    Navigator.pop(context);
  }

  Future<void> _getAddressSuggestions(String query) async {
    final String apiKey = "pk.cd2419e57227bf0251df9f4b641c2286";
    final url = Uri.parse(
        "https://us1.locationiq.com/v1/search?key=$apiKey&q=$query&format=json&countrycodes=US&limit=5");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _addressSuggestions = List<String>.from(
              data.map((item) {
                final display = item['display_name'] ?? '';
                final parts = display.split(',').map((s) => s.trim()).toList();

                final houseNumber = parts.length > 0 ? parts[0] : '';
                final street = parts.length > 1 ? parts[1] : '';
                final rawCity = parts.length > 2 ? parts[2] : '';
                final city = rawCity.replaceAll(RegExp(r'^(Town of|City of)\s*'), '');
                final state = parts.length > 5 ? parts[5] : '';
                final zip = parts.length > 6 ? parts[6] : '';

                return '$houseNumber $street, $city, $state $zip';
              })
          );
        });

      } else {
        throw Exception("Failed to load address suggestions");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _onAddressChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        _getAddressSuggestions(value);
      } else {
        setState(() {
          _addressSuggestions = [];
        });
      }
    });
    _isAddressSelectedFromSuggestions = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Delivery Address")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "Enter your address"),
              onChanged: _onAddressChanged,
            ),
            SizedBox(height: 20),
            if (_addressSuggestions.isNotEmpty)
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: _addressSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_addressSuggestions[index]),
                      onTap: () {
                        _addressController.text = _addressSuggestions[index];
                        _isAddressSelectedFromSuggestions = true;
                        setState(() {
                          _addressSuggestions = [];
                        });
                      },
                    );
                  },
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _submitAddress();
                if (mounted) Navigator.pushNamed(context, "/customer-home");
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
