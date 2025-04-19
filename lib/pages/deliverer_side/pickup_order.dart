import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:DormDash/widgets/pickup_delivery_details_template.dart';
import 'package:DormDash/widgets/bottom-nav-bar.dart';
import '/pages/deliverer_side/deliverer-chat.dart';
import '../../widgets/chat_manager.dart';
import '../../widgets/status_manager.dart';
import '/pages/deliverer_side/deliver_order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersPage extends StatefulWidget {
  final String orderId;
  const OrdersPage({super.key, required this.orderId});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Map<String, dynamic>? orderData;
  bool isDropdownVisible = false;
  LatLng? destinationLatLng;
  LatLng? currentLatLng;

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

  void _launchDirections(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
  ) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&origin=$originLat,$originLng"
      "&destination=$destLat,$destLng"
      "&travelmode=driving",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orderData == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Please select an order to deliver.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final Timestamp orderTimestamp = orderData!['orderTime'] as Timestamp;
    final DateTime pickupTime = orderTimestamp.toDate().add(
      Duration(minutes: 20),
    );
    final pickupTimeFormatted = DateFormat('h:mm a').format(pickupTime);
    final String restaurantAddress =
        orderData!['restaurantAddress'] ?? "Unknown Address";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pickup by $pickupTimeFormatted',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
          Flexible(
            flex: 1,
            child: PickupMapSection(
              destinationAddress: restaurantAddress,
              orderId: widget.orderId,
              onLocationLoaded: (latLng, currentLoc) {
                destinationLatLng = latLng;
                currentLatLng = currentLoc;
              },
            ),
          ),
          DeliveryDetailsCard(
            typeLabel: "Pickup From",
            title: orderData!['restaurantName'] ?? "Unknown Restaurant",
            address: restaurantAddress,
            customerName: orderData!['customerFirstName'] ?? "Unknown Customer",
            itemCount: (orderData!['Items'] as List).length,
            onCallTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Phone Number Unavailable"),
                      content: const Text(
                        "The restaurant's number has not been set up yet.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
              );
            },
            onDirectionsTap: () {
              if (currentLatLng != null && destinationLatLng != null) {
                _launchDirections(
                  currentLatLng!.latitude,
                  currentLatLng!.longitude,
                  destinationLatLng!.latitude,
                  destinationLatLng!.longitude,
                );
              }
            },
            onSlideComplete: () async {
              StatusManager.advanceStatus();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          Scaffold(body: DeliverOrder(orderId: widget.orderId)),
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
            orderItems: orderData!['Items'] ?? [],
            items: orderData!['Items'] ?? [],
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
  final String destinationAddress;
  final String orderId;
  final Function(LatLng, LatLng) onLocationLoaded;
  const PickupMapSection({
    super.key,
    required this.destinationAddress,
    required this.orderId,
    required this.onLocationLoaded,
  });

  @override
  State<PickupMapSection> createState() => _PickupMapSectionState();
}

class _PickupMapSectionState extends State<PickupMapSection> {
  loc.Location _location = loc.Location();
  LatLng? _currentLocation;
  LatLng? _destinationLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();
    _geocodeDestination();
  }

  void _getLocationUpdates() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    _location.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        final lat = locationData.latitude!;
        final lng = locationData.longitude!;
        final updatedLatLng = LatLng(lat, lng);
        if (mounted) {
          setState(() {
            _currentLocation = updatedLatLng;
          });
          _mapController?.animateCamera(CameraUpdate.newLatLng(updatedLatLng));
          if (_destinationLocation != null) {
            widget.onLocationLoaded(_destinationLocation!, updatedLatLng);
          }
        }
        FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderId)
            .update({'delivererLat': lat, 'delivererLng': lng});
      }
    });
  }

  void _geocodeDestination() async {
    try {
      List<Location> locations = await locationFromAddress(
        widget.destinationAddress,
      );
      if (locations.isNotEmpty) {
        setState(() {
          _destinationLocation = LatLng(
            locations.first.latitude,
            locations.first.longitude,
          );
        });
        if (_currentLocation != null) {
          widget.onLocationLoaded(_destinationLocation!, _currentLocation!);
        }
      }
    } catch (e) {
      print("Geocoding failed: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null || _destinationLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentLocation!,
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("userLocation"),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId("pickupLocation"),
          position: _destinationLocation!,
          icon: BitmapDescriptor.defaultMarker,
        ),
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (controller) {
        _mapController = controller;
      },
    );
  }
}
