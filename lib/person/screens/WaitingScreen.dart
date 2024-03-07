import 'package:construction/common/colors.dart';
import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/models/orders.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/person/screens/HomeScreenPerson.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WaitingScreen extends StatefulWidget {
  final Organize restaurant;
  final Orders orders;
  const WaitingScreen({required this.restaurant, required this.orders});
  @override
  _WaitingScreenState createState() =>
      _WaitingScreenState(restaurant: restaurant, orders: orders);
}

class _WaitingScreenState extends State<WaitingScreen> {
  final Orders orders;
  _WaitingScreenState({required this.restaurant, required this.orders});
  late GoogleMapController _mapController;
  bool _isLoading = false;
  final Organize restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Icon(Icons.timer),
                          const SizedBox(width: 10),
                          const Text(
                            'Preparation Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              '00:15:59',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  width: 50,
                                  height: 2,
                                  color: Colors.green,
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  width: 50,
                                  height: 2,
                                  color: Colors.grey[300],
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'Received',
                                  style: TextStyle(
                                    color: secondaryColor,
                                  ),
                                ),
                                const Text(
                                  'Preparing',
                                  style: TextStyle(
                                    color: secondaryColor,
                                  ),
                                ),
                                const Text(
                                  'Ready',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Icon(Icons.map),
                          const SizedBox(width: 10),
                          const Text(
                            'Map',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        height: 300,
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                restaurant.latitude!, restaurant.longitude!),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId("marker"),
                              position: LatLng(
                                  restaurant.latitude!, restaurant.longitude!),
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomIconButton(
                label: 'Done',
                icon: Icons.done,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreenPerson(),
                  ),
                ),
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
