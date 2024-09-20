import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:red/screens/book_service_map.dart';
import 'package:red/widgets/map_text_field.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  String _currentAddress = 'Fetching address...';
  LatLng _mapCenter = const LatLng(13.0843, 80.2705);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      _moveCameraToPosition(currentLatLng);
      _updateAddress(currentLatLng);
    } else if (status.isDenied) {
      setState(() {
        _currentAddress = 'Location permission denied.';
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _moveCameraToPosition(LatLng position) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(position, 15), // Adjust zoom level if needed
      );
      setState(() {
        _mapCenter = position;
      });
    }
  }

  Future<void> _updateAddress(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.thoroughfare ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}';
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching address: $e");
      }
    }
  }

  Future<void> _searchAndNavigate(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        LatLng searchLatLng =
            LatLng(locations[0].latitude, locations[0].longitude);
        _moveCameraToPosition(searchLatLng);
        _updateAddress(searchLatLng);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error searching location: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _mapCenter,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onCameraMove: (CameraPosition position) {
              setState(() {
                _mapCenter = position.target;
              });
            },
            onCameraIdle: () {
              _updateAddress(_mapCenter);
            },
          ),
          const Center(
            child: Icon(
              Icons.location_on_sharp,
              size: 35,
              color: Color.fromARGB(255, 49, 121, 46),
            ),
          ),
          CurvedTextField(
            onSubmitted: (text) {
              _searchAndNavigate(text);
            },
            controller: _searchController,
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _getCurrentLocation,
                        child: const Icon(
                          Icons.location_on_outlined,
                          size: 25,
                          color: Color.fromARGB(255, 49, 121, 46),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Area Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _currentAddress,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.start,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookServiceMap(
                                    location: _mapCenter,
                                    address: _currentAddress,
                                  )));
                    },
                    child: const Text(
                      'Confirm Location',
                      style: TextStyle(
                          color: Color.fromARGB(255, 49, 121, 46),
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 170,
            right: 10,
            child: SizedBox(
              height: 45,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: _getCurrentLocation,
                child: const Icon(
                  Icons.my_location,
                  size: 28,
                  color: Color.fromARGB(255, 49, 121, 46),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
