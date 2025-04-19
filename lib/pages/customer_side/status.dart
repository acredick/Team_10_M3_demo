import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import '/widgets/customer_page.dart';
import '/pages/customer_side/customer_chat.dart';
import 'package:DormDash/widgets/bottom-nav-bar.dart';
import '../../widgets/chat_manager.dart';
import '/pages/customer_side/rate_deliverer.dart';

class Status extends StatefulWidget {
  final String? orderID;
  const Status({super.key, required this.orderID});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  late Stream<DocumentSnapshot> orderStream;
  bool isDropdownVisible = false;
  int statusInt = -1;
  bool hasNavigatedToRating = false;
  Map<String, dynamic>? orderData;

  @override
  void initState() {
    super.initState();
    orderStream =
        FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderID)
            .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Status",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: Colors.black),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text("Place an order to see its status."),
            );
          }

          var order = snapshot.data!;
          orderData = order.data() as Map<String, dynamic>;

          String address = orderData!['address'] ?? 'Unknown';
          int itemCount = (orderData!['Items'] as List).length;
          List<dynamic> items = orderData!['Items'] ?? [];
          double price = orderData!['price'] ?? 0.0;
          String restaurantName = orderData!['restaurantName'] ?? 'Unknown';
          String orderId = orderData!['orderID'];
          String dasher =
              orderData!['delivererFirstName'] == ""
                  ? "Waiting on a DormDasher..."
                  : "${orderData!['delivererFirstName']}";

          int newStatusInt =
              (orderData!['status'] is String)
                  ? int.tryParse(orderData!['status']) ?? -1
                  : orderData!['status'];

          if (newStatusInt != statusInt) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  statusInt = newStatusInt;
                });
              }
            });
          }

          if (statusInt == 3 && !hasNavigatedToRating) {
            hasNavigatedToRating = true;
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          Scaffold(body: RateDeliverer(orderId: orderId)),
                ),
              );
            });
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: CustomerMapSection(
                  destinationAddress: address,
                  orderData: orderData!,
                ),
              ),
              DeliveryDetailsCard(
                customerName: dasher,
                typeLabel: "Your DormDasher",
                address: address,
                onDirectionsTap: () {},
                onChatTap: () {
                  if (dasher == "Waiting on a DormDasher...") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Chat Unavailable'),
                          content: const Text(
                            'We are still waiting for a Dasher to accept your order. Hang tight!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Scaffold(
                              body: CustomerChatScreen(
                                chatID: ChatManager.getRecentChatID(),
                              ),
                              bottomNavigationBar: CustomBottomNavigationBar(
                                selectedIndex: 0,
                                onItemTapped: (index) {},
                                userType: "customer",
                              ),
                            ),
                      ),
                    );
                  }
                },
                title: restaurantName,
                status: _getOrderStatus(orderData!['status']),
                price: price,
                itemCount: itemCount,
                isDropdownVisible: isDropdownVisible,
                onExpandTap: () {
                  setState(() {
                    isDropdownVisible = !isDropdownVisible;
                  });
                },
                orderItems: items,
                items: items,
              ),
            ],
          );
        },
      ),
    );
  }

  String _getOrderStatus(dynamic status) {
    int localStatusInt =
        (status is String) ? int.tryParse(status) ?? -1 : status;
    switch (localStatusInt) {
      case 0:
        return 'Placed';
      case 1:
        return 'Waiting for pickup';
      case 2:
        return 'Out for delivery';
      case 3:
        return 'Delivered';
      case 4:
        return 'Complete';
      default:
        return 'Unknown Status';
    }
  }
}

class CustomerMapSection extends StatefulWidget {
  final String destinationAddress;
  final Map<String, dynamic> orderData;

  const CustomerMapSection({
    super.key,
    required this.destinationAddress,
    required this.orderData,
  });

  @override
  State<CustomerMapSection> createState() => _CustomerMapSectionState();
}

class _CustomerMapSectionState extends State<CustomerMapSection> {
  loc.Location _location = loc.Location();
  LatLng? _customerLatLng;
  LatLng? _delivererLatLng;
  LatLng? _restaurantLatLng = const LatLng(
    42.6864,
    -73.8236,
  ); // UAlbany Campus Center

  @override
  void initState() {
    super.initState();
    _geocodeCustomerAddress();
  }

  void _geocodeCustomerAddress() async {
    try {
      List<Location> locations = await locationFromAddress(
        widget.destinationAddress,
      );
      if (locations.isNotEmpty) {
        setState(() {
          _customerLatLng = LatLng(
            locations.first.latitude,
            locations.first.longitude,
          );
        });
      }
    } catch (e) {
      print("Geocoding failed: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_customerLatLng == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.orderData['status'] >= 1 &&
        widget.orderData['delivererLat'] != null &&
        widget.orderData['delivererLng'] != null) {
      _delivererLatLng = LatLng(
        widget.orderData['delivererLat'],
        widget.orderData['delivererLng'],
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _customerLatLng!, zoom: 15),
      markers: {
        Marker(
          markerId: const MarkerId("customerLocation"),
          position: _customerLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        if (_delivererLatLng != null)
          Marker(
            markerId: const MarkerId("delivererLocation"),
            position: _delivererLatLng!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        Marker(
          markerId: const MarkerId("restaurant"),
          position: _restaurantLatLng!,
          infoWindow: InfoWindow(
            title: widget.orderData['restaurantName'] ?? "Restaurant",
          ),
        ),
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }
}
