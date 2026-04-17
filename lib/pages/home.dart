import 'package:flutter/cupertino.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppleMapController mapController;
  double speed = 67.0; // This will be updated by GPS data later

  void _onMapCreated(AppleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Row(
        children: [
          // Left half - Speed Display
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Speed',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${speed.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: CupertinoColors.systemGreen,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'km/h',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right half - Apple Map
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AppleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.7749, -122.4194), // San Francisco
                    zoom: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

