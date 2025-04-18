import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:DormDash/widgets/pickup_delivery_details_template.dart';
import 'package:DormDash/widgets/bottom-nav-bar.dart';
import '/pages/deliverer_side/deliverer-chat.dart';
import '../../widgets/chat_manager.dart';
import '../../widgets/status_manager.dart';
import '/pages/deliverer_side/deliver_order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';


class OrdersPage extends StatefulWidget {
  final String orderId;
  const OrdersPage({super.key, required this.orderId});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Map<String, dynamic>? orderData;
  bool isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  void fetchOrderDetails() async {
    DocumentSnapshot orderSnapshot =
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .get();

    if (orderSnapshot.exists) {
      setState(() {
        orderData = orderSnapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure orderData is not null
    if (orderData == null) {
      return Scaffold(
        body: Center(child: Text("Please select an order to deliver.", style: TextStyle(fontSize: 18))),
      );
    }

    // Safely get the orderTime and calculate pickupTime if orderData is not null
    final Timestamp orderTimestamp = orderData!['orderTime'] as Timestamp;
    final DateTime pickupTime = orderTimestamp.toDate().add(Duration(minutes: 20));
    final pickupTimeFormatted = DateFormat('h:mm a').format(pickupTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pickup by $pickupTimeFormatted',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // prevents back button
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 1, child: PickupMapSection()),
          DeliveryDetailsCard(
            typeLabel: "Pickup From",
            title: orderData!['restaurantName'] ?? "Unknown Restaurant",
            address: orderData!['restaurantAddress'] ?? "Unknown Address",
            customerName: orderData!['customerFirstName'] ?? "Unknown Customer",
            itemCount: (orderData!['Items'] as List).length,
            onCallTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Phone Number Unavailable"),
                  content: const Text("The restaurant's number has not been set up yet."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
            onDirectionsTap: () {}, // TODO: Add navigation functionality
            onSlideComplete: () async {
              print("Order picked up. Advancing status...");
              StatusManager.advanceStatus();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Scaffold(
                    body: DeliverOrder(orderId: widget.orderId),
                  ),
                ),
              );
            },
            onChatTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Scaffold(
                    body: DelivererChatScreen(
                      chatID: ChatManager.getRecentChatID(),
                    ),
                    bottomNavigationBar: CustomBottomNavigationBar(
                      selectedIndex: 0,
                      onItemTapped: (index) {},
                      userType: "deliverer",
                    ),
                  ),
                ),
              );
            },
            isDropdownVisible: isDropdownVisible,
            onExpandTap: () {
              setState(() {
                isDropdownVisible = !isDropdownVisible;
              });
            },
            orderItems: orderData!['Items'] ?? [], items: orderData!['Items'] ?? [],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1,
        onItemTapped: (index) {},
        userType: "deliverer",
      ),
    );
  }
}

class PickupMapSection extends StatefulWidget {
  @override
  State<PickupMapSection> createState() => _PickupMapSectionState();
}

class _PickupMapSectionState extends State<PickupMapSection> {
  Location _location = Location();
  LatLng? _currentLocation;

  final LatLng _pickupLocation = LatLng(
    42.6861,
    -73.8238,
  ); // Campus Center, UAlbany

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _pickupLocation, zoom: 15),
      markers: {
        Marker(
          markerId: const MarkerId("userLocation"),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId("pickupLocation"),
          position: _pickupLocation,
          icon: BitmapDescriptor.defaultMarker,
        ),
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }

  void _getLocationUpdates() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _location.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
        });
      }
    });
  }
}
