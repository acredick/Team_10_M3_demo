import 'package:flutter/material.dart';
import 'package:DormDash/widgets/dropoff_delivery_details_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '/pages/deliverer_side/deliverer-chat.dart';
import 'package:DormDash/widgets/bottom-nav-bar.dart';
import '/pages/shared/chat_manager.dart';
import 'package:DormDash/pages/shared/order_manager.dart';
import '/pages/shared/status_manager.dart';

class DeliverOrder extends StatelessWidget {
  const DeliverOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deliver by 11:08 PM',
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
      body: Column(
        children: [
          SizedBox(height: 380, width: double.infinity, child: MapSection()),
          Expanded(
            child: DeliveryDetailsCard(
              customerName: "Jeff",
              typeLabel: "Dropoff To",
              address:
                  "1400 Washington Ave\nUniversity Library\nAlbany, NY, 12222",
              itemCount: 2,
              onCallTap: () {}, //TODO: add later
              onDirectionsTap: () {}, // TODO: add later
              onChatTap:  () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Scaffold(
                      body: DelivererChatScreen(chatID: ChatManager.getRecentChatID()),
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
                StatusManager.advanceStatus();
                Navigator.pushNamed(context, "/dropoff-confirmation");
              },
            ),
          ),
        ],
      ),
    );
  }
}

// map widget using google maps API.
// is currently hardcoded to the default order location
// should display users current location as well the intended location
// you have to set your location in the emulator manually, or a route to see it moving.
// to do so, click the elipses in the bottom right, go to location, and set a location, or a route.
class MapSection extends StatefulWidget {
  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  Location _location = Location();
  LatLng? _currentLocation;

  final LatLng _dropoffLocation = LatLng(
    42.6864,
    -73.8236,
  ); // University Library

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
