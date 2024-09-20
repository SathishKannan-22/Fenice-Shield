// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import '../widgets/map_text_field.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   MapScreenState createState() => MapScreenState();
// }

// class MapScreenState extends State<MapScreen> {
//   LatLng _currentLocation = const LatLng(13.0843, 80.2705);
//   String _areaName = 'Area name';
//   String _address = 'Address';

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         GoogleMap(
//           onMapCreated: (controller) {
//             // Handle map creation
//           },
//           onCameraMove: (position) {},
//           initialCameraPosition: CameraPosition(
//             target: _currentLocation,
//             zoom: 13.0,
//           ),
//         ),
//         // CurvedTextField(onSubmitted: _moveToAddress,),
//         const Center(
//           child: Material(
//             color: Colors.transparent,
//             elevation: 10.0,
//             shape: CircleBorder(),
//             child: Icon(
//               Icons.location_on,
//               size: 40,
//               color: Color.fromARGB(255, 49, 121, 46),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 40,
//           left: 40,
//           right: 40,
//           height: 140,
//           child: Container(
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on_outlined,
//                       color: Color.fromARGB(255, 49, 121, 46),
//                       size: 28,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       _areaName,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20),
//                   child: Text(
//                     _address,
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 ),
//                 const Divider(
//                   thickness: 2,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         'Confirm Location',
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 49, 121, 46),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
