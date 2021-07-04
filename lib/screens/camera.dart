import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController cameraController;
  List cameras;
  int selectedCameraIndex;
  String imgPath;
  bool _isInside = false;
  bool _isLoading = true;

  String leftArrowDistance = "0";
  String rightArrowDistance = "0";
  String upArrowDistance = "0";
  String downArrowDistance = "0";

  Location location = new Location();

  LatLng point01 = LatLng();
  LatLng point02 = LatLng();
  LatLng point03 = LatLng();
  LatLng point04 = LatLng();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  void checkPermissions() async {
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController.dispose();
    }

    cameraController =
        CameraController(cameraDescription, ResolutionPreset.veryHigh);

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController.value.hasError) {
      print('Camera Error ${cameraController.value.errorDescription}');
    }

    try {
      await cameraController.initialize();
    } catch (e) {
      showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget cameraPreview() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text(
        'Loading',
        style: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    }

    return CameraPreview(cameraController);
  }

  @override
  void initState() {
    super.initState();

    location.onLocationChanged.listen((LocationData currentLocation) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          upArrowDistance = PolygonUtil.distanceToLine(
                  LatLng(currentLocation.latitude, currentLocation.longitude),
                  point01,
                  point02)
              .toStringAsFixed(2);

          rightArrowDistance = PolygonUtil.distanceToLine(
                  LatLng(currentLocation.latitude, currentLocation.longitude),
                  point02,
                  point03)
              .toStringAsFixed(2);

          downArrowDistance = PolygonUtil.distanceToLine(
                  LatLng(currentLocation.latitude, currentLocation.longitude),
                  point03,
                  point04)
              .toStringAsFixed(2);

          leftArrowDistance = PolygonUtil.distanceToLine(
                  LatLng(currentLocation.latitude, currentLocation.longitude),
                  point04,
                  point01)
              .toStringAsFixed(2);

          _isInside = PolygonUtil.containsLocation(
              LatLng(currentLocation.latitude, currentLocation.longitude),
              [
                point01,
                point02,
                point03,
                point04,
              ],
              true);
          print(_isInside);
        });
      }
    });

    checkPermissions();
    availableCameras().then((value) {
      cameras = value;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        initCamera(cameras[selectedCameraIndex]).then((value) {});
      } else {
        print('No camera available');
      }
    }).catchError((e) {
      print('Error : ${e.code}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: <Widget>[
            cameraPreview(),
            Align(
              alignment: Alignment.center,
              child: _isLoading
                  ? Text("Determinando ubicación")
                  : (_isInside
                      ? Text(
                          "Estas dentro del terreno",
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 16),
                        )
                      : Text(
                          "No estas dentro del terreno",
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 16),
                        )),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_drop_up,
                    size: 100,
                    color: _isInside ? Colors.greenAccent : Colors.redAccent,
                  ),
                  Text(
                    upArrowDistance + " mts",
                    style: TextStyle(
                        color:
                            _isInside ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(downArrowDistance + " mts",
                        style: TextStyle(
                            color: _isInside
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontSize: 16)),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 100,
                      color: _isInside ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_left,
                      size: 100,
                      color: _isInside ? Colors.greenAccent : Colors.redAccent,
                    ),
                    Text(
                      leftArrowDistance + " mts",
                      style: TextStyle(
                          color:
                              _isInside ? Colors.greenAccent : Colors.redAccent,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_right,
                      size: 100,
                      color: _isInside ? Colors.greenAccent : Colors.redAccent,
                    ),
                    Text(
                      rightArrowDistance + " mts",
                      style: TextStyle(
                          color:
                              _isInside ? Colors.greenAccent : Colors.redAccent,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showCameraException(e) {
    String errorText = 'Error ${e.code} \nError message: ${e.description}';
  }
}
