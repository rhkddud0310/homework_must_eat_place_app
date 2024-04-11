import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

class GPSLocation extends StatefulWidget {
  const GPSLocation({super.key});

  @override
  State<GPSLocation> createState() => _GPSLocationState();
}

class _GPSLocationState extends State<GPSLocation> {
  // Property
  late Position currentPosition;
  late double latData;
  late double longData;
  late MapController mapController;
  late bool canRun;

  var value = Get.arguments ?? '___';

// ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    canRun = false;
    checkLocationPermission();

    latData = double.parse(value[0]);
    longData = double.parse(value[1]);
  }

  // ---------------------------------------------------------------------------

  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      getCurrentLocation();
    }
  }

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((position) {
      // currentPosition = position;
      canRun = true;
      latData = latData;
      longData = longData;
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '위치 보기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      ),
      body: canRun
          ? flutterMap()
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  // ---------------------------------------------------------------------------

  // --- Widgets ----
  Widget flutterMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(latData, longData),
        initialZoom: 17.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80,
              height: 80,
              point: latlng.LatLng(latData, longData),
              child: const Icon(
                Icons.pin_drop_outlined,
                size: 50,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }
} // End
