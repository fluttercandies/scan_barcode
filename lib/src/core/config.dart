import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

class ScanConfig extends ChangeNotifier {
  ScanConfig({
    this.cameraConfig = const CameraConfig(),
    this.barcodeConfig = const BarcodeConfig(),
    this.uiConfig = const UIConfig(),
  });

  CameraConfig cameraConfig;
  BarcodeConfig barcodeConfig;
  UIConfig uiConfig;

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

class CameraConfig {
  const CameraConfig({
    this.isAutoFocus = true,
    this.clickToFocus = true,
  });

  final bool isAutoFocus;
  final bool clickToFocus;

  CameraConfig copyWith({
    bool? isAutoFocus,
    bool? clickToFocus,
  }) {
    return CameraConfig(
      isAutoFocus: isAutoFocus ?? this.isAutoFocus,
      clickToFocus: clickToFocus ?? this.clickToFocus,
    );
  }
}

class BarcodeConfig {
  const BarcodeConfig({
    this.formats = const [BarcodeFormat.all],
  });

  final List<BarcodeFormat> formats;

  BarcodeConfig copyWith({
    List<BarcodeFormat>? formats,
  }) {
    return BarcodeConfig(
      formats: formats ?? this.formats,
    );
  }
}

class UIConfig {
  const UIConfig();
}
