import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

part 'barcode.dart';

part 'camera.dart';

part 'ui.dart';

class ScanValue extends ChangeNotifier {
  ScanValue({
    this.cameraConfig = const CameraConfig(),
    this.barcodeConfig = const BarcodeConfig(),
    this.uiConfig = const UIConfig(),
  });

  CameraConfig cameraConfig;
  BarcodeConfig barcodeConfig;
  UIConfig uiConfig;
  CameraController? cameraController;

  void updateCameraConfig(CameraConfig config) {
    cameraConfig = config;
    notifyListeners();
  }

  void updateBarcodeConfig(BarcodeConfig config) {
    barcodeConfig = config;
    notifyListeners();
  }

  void updateUIConfig(UIConfig config) {
    uiConfig = config;
    notifyListeners();
  }
}
