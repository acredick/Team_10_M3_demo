import 'package:flutter/material.dart';
import 'package:DormDash/widgets/dropoff_delivery_details_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import '/pages/deliverer_side/deliverer-chat.dart';
import '../../widgets/chat_manager.dart';
import 'package:DormDash/widgets/status_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '/widgets/bottom-nav-bar.dart';
import 'package:DormDash/widgets/order_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliverOrder extends StatefulWidget {
  final String orderId;
  const DeliverOrder({super.key, required this.orderId});

  @override
  _DeliverOrderState createState() => _DeliverOrderState();
}

class _DeliverOrderState extends State<DeliverOrder> {
  Map<String, dynamic>? orderData;
  bool isDropdownVisible = false;
  LatLng? dropoffLatLng;
  LatLng? currentLatLng;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
    OrderManager.getChatIDFromOrder(widget.orderId);
    print("Chat ID in DeliverOrder: \${ChatManager.getRecentChatID()}");
  }

  void fetchOrderDetails() async {
    DocumentSnapshot orderSnapshot =
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderId)
            .get();

    if (orderSnapshot.exists) {
      setState(() {
        orderData = orderSnapshot.data() as Map<String, dynamic>;
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

    final Timestamp orderTimestamp = orderData!['orderTime'];
    final DateTime orderTime = orderTimestamp.toDate();
    final DateTime deliverByTime = orderTime.add(Duration(minutes: 45));
    final deliverByTimeFormatted = DateFormat('h:mm a').format(deliverByTime);

    final String deliveryAddress = orderData!['address'] ?? "Unknown Address";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deliver by $deliverByTimeFormatted',
          style: const TextStyle(color: Colors.black),
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
            child: MapSection(
              destinationAddress: deliveryAddress,
              orderId: widget.orderId,
              onLocationLoaded: (latLng, currentLoc) {
                dropoffLatLng = latLng;
                currentLatLng = currentLoc;
              },
            ),
          ),
          DeliveryDetailsCard(
            typeLabel: "Dropoff to",
            address: deliveryAddress,
            customerName: orderData!['customerFirstName'] ?? "Unknown Customer",
            itemCount: (orderData!['Items'] as List).length,
            onDirectionsTap: () {
              if (currentLatLng != null && dropoffLatLng != null) {
                _launchDirections(
                  currentLatLng!.latitude,
                  currentLatLng!.longitude,
                  dropoffLatLng!.latitude,
                  dropoffLatLng!.longitude,
                );
              }
            },
            isDropdownVisible: isDropdownVisible,
            onExpandTap: () {
              setState(() {
                isDropdownVisible = !isDropdownVisible;
              });
            },
            orderItems: orderData!['Items'] ?? [],
            items: orderData!['Items'] ?? [],
            onChatTap: () {
              Navigator.push(
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
            onSlideComplete: () async {
              print("Order delivered. Advancing status...");
              StatusManager.advanceStatus();
              Navigator.pushNamed(context, "/dropoff-confirmation");
            },
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

class MapSection extends StatefulWidget {
  final String destinationAddress;
  final String orderId;
  final Function(LatLng, LatLng) onLocationLoaded;
  const MapSection({
    super.key,
    required this.destinationAddress,
    required this.orderId,
    required this.onLocationLoaded,
  });

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  loc.Location _location = loc.Location();
  LatLng? _currentLocation;
  LatLng? _dropoffLocation;
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
          if (_dropoffLocation != null) {
            widget.onLocationLoaded(_dropoffLocation!, updatedLatLng);
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
          _dropoffLocation = LatLng(
            locations.first.latitude,
            locations.first.longitude,
          );
        });
        if (_currentLocation != null) {
          widget.onLocationLoaded(_dropoffLocation!, _currentLocation!);
        }
      }
    } catch (e) {
      print("Geocoding failed: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null || _dropoffLocation == null) {
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
          markerId: const MarkerId("dropoffLocation"),
          position: _dropoffLocation!,
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
