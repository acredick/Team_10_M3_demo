import 'package:flutter/material.dart';
import 'package:DormDash/widgets/dropoff_delivery_details_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '/pages/deliverer_side/deliverer-chat.dart';
import '/pages/shared/chat_manager.dart';
import 'package:DormDash/pages/shared/status_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/widgets/bottom-nav-bar.dart';

class DeliverOrder extends StatefulWidget {
  final String orderId;
  const DeliverOrder({super.key, required this.orderId});

  @override
  _DeliverOrderState createState() => _DeliverOrderState();
}

class _DeliverOrderState extends State<DeliverOrder> {
  Map<String, dynamic>? orderData;
  bool isDropdownVisible = false;

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orderData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Loading...',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.help_outline, color: Colors.black),
            ),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deliver by 11:08 PM', // todo remove hardcode
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // prevents back button
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            // TODO: make widget for help icons for status pages. these would allow people to troubleshoot stuff
            child: Icon(Icons.help_outline, color: Colors.black),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: MapSection(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: DeliveryDetailsCard(
                  typeLabel: "Dropoff to",
                  address: orderData!['restaurantAddress'] ?? "Unknown Address",
                  customerName: orderData!['customerFirstName'] ?? "Unknown Customer",
                  itemCount: (orderData!['Items'] as List).length,
                  onCallTap: () {}, //TODO: add later
                  onDirectionsTap: () {}, // TODO: add later
                  isDropdownVisible: isDropdownVisible,
                  onExpandTap: () {
                    setState(() {
                      isDropdownVisible = !isDropdownVisible;
                    });
                  },
                  orderItems: orderData!['Items'] ?? [], items: orderData!['Items'] ?? [],
                  onChatTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: DelivererChatScreen(chatID: ChatManager.getRecentChatID()),
                        ),
                      ),
                    );
                  },
                  onSlideComplete: () async {
                    print("Order delivered. Advancing status...");
                    StatusManager.advanceStatus();
                    Navigator.pushNamed(context, "/dropoff-confirmation");
                  },
                ),
              ),
            ),
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

// Map widget using google maps API
class MapSection extends StatefulWidget {
  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  Location _location = Location();
  LatLng? _currentLocation;

  final LatLng _dropoffLocation = const LatLng(42.6864, -73.8236); // University Library

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
      initialCameraPosition: CameraPosition(target: _dropoffLocation, zoom: 15),
      markers: {
        Marker(
          markerId: const MarkerId("userLocation"),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId("dropoffLocation"),
          position: _dropoffLocation,
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
