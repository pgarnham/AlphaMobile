import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

class CameraScreen extends StatefulWidget {
  final List coord1;
  final List coord2;
  final List coord3;
  final List coord4;
  CameraScreen(this.coord1, this.coord2, this.coord3, this.coord4);
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

  LatLng point01;
  LatLng point02;
  LatLng point03;
  LatLng point04;

  void setPoints() {
    point01 = LatLng(widget.coord1[0], widget.coord1[1]);
    point02 = LatLng(widget.coord2[0], widget.coord2[1]);
    point03 = LatLng(widget.coord3[0], widget.coord3[1]);
    point04 = LatLng(widget.coord4[0], widget.coord4[1]);
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
        'Abriendo camara',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      );
    }

    return CameraPreview(cameraController);
  }

  @override
  void initState() {
    super.initState();
    setPoints();
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
              child: Container(
                child: _isLoading
                    ? Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            border: Border.all(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Determinando ubicación",
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 16),
                        ),
                      )
                    : (_isInside
                        ? Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                border: Border.all(color: Colors.greenAccent),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "Estás dentro del terreno",
                              style: TextStyle(
                                  color: Colors.greenAccent, fontSize: 16),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                border: Border.all(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "No estás dentro del terreno",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 16),
                            ),
                          )),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.arrow_drop_up,
                      size: 100,
                      color: _isInside ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                  _isInside
                      ? Text(
                          upArrowDistance + " mts",
                          style: TextStyle(
                              color: _isInside
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontSize: 20),
                        )
                      : SizedBox.shrink(),
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
                    _isInside
                        ? Text(downArrowDistance + " mts",
                            style: TextStyle(
                                color: _isInside
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontSize: 20))
                        : SizedBox.shrink(),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 100,
                      color: _isInside ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Icon(
                      Icons.arrow_left,
                      size: 100,
                      color: _isInside ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                  _isInside
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            leftArrowDistance + " mts",
                            style: TextStyle(
                                color: _isInside
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontSize: 20),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Icon(
                      Icons.arrow_right,
                      size: 100,
                      color: _isInside ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                  _isInside
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            rightArrowDistance + " mts",
                            style: TextStyle(
                                color: _isInside
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontSize: 20),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
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
