// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/foundation.dart';
// import '../widgets/map_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _currentPosition;
//   String _currentAddress = 'Fetching address...';

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();

//     if (status.isGranted) {
//       Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _getAddressFromLatLng(position.latitude, position.longitude);
//       });
//       _mapController
//           ?.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 15));
//     } else if (status.isDenied) {
//       // Permission denied, handle accordingly.
//       setState(() {
//         _currentAddress = 'Location permission denied.';
//       });
//     } else if (status.isPermanentlyDenied) {
//       // Permission permanently denied, open settings.
//       openAppSettings();
//     }
//   }

//   Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     Placemark place = placemarks[0];
//     setState(() {
//       _currentAddress =
//           '${place.thoroughfare},${place.subLocality},${place.locality},${place.administrativeArea}, ${place.postalCode}, ${place.country}';
//     });
//   }

//   Future<void> _moveToAddress(String address) async {
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         final location = locations[0];
//         LatLng newPosition = LatLng(location.latitude, location.longitude);
//         setState(() {
//           _currentPosition = newPosition;
//           _getAddressFromLatLng(location.latitude, location.longitude);
//         });
//         _mapController?.animateCamera(
//           CameraUpdate.newLatLngZoom(newPosition, 15),
//         );
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error finding location: $e");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _currentPosition ?? const LatLng(13.0843, 80.2705),
//               zoom: 15,
//             ),
//             onMapCreated: (controller) {
//               _mapController = controller;
//             },
//             zoomControlsEnabled: false,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             markers: _currentPosition == null
//                 ? {}
//                 : {
//                     Marker(
//                       markerId: const MarkerId('current_location'),
//                       position: _currentPosition!,
//                       icon: BitmapDescriptor.defaultMarkerWithHue(
//                           BitmapDescriptor.hueGreen),
//                     ),
//                   },
//           ),
//           if (_currentPosition != null)
//             Positioned(
//               bottom: 30,
//               left: 40,
//               right: 40,
//               child: Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(8),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: const [
//                           Icon(
//                             Icons.location_on_outlined,
//                             size: 25,
//                             color: Color.fromARGB(255, 49, 121, 46),
//                           ),
//                           Text(
//                             'Area Name',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         _currentAddress,
//                         style: const TextStyle(color: Colors.grey),
//                         textAlign: TextAlign.start,
//                       ),
//                       const Divider(
//                         thickness: 2,
//                       ),
//                       ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                           ),
//                           onPressed: (() {}),
//                           child: const Text(
//                             'Confirm Location',
//                             style: TextStyle(
//                                 color: Color.fromARGB(255, 49, 121, 46),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 17),
//                           ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           CurvedTextField(
//             onSubmitted: _moveToAddress,
//           ),
//           Positioned(
//               bottom: 170,
//               right: 10,
//               child: SizedBox(
//                 height: 45,
//                 child: FloatingActionButton(
//                   backgroundColor: Colors.white,
//                   onPressed: () {
//                     _mapController?.animateCamera(
//                       CameraUpdate.newLatLngZoom(_currentPosition!, 15),
//                     );
//                   },
//                   child: const Icon(
//                     Icons.my_location,
//                     size: 28,
//                     color: Color.fromARGB(255, 49, 121, 46),
//                   ),
//                 ),
//               ))
//         ],
//       ),
//     );
//   }
// }
