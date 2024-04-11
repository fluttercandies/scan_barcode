import 'package:flutter/foundation.dart';

enum BarcodeScanStatus {
  init,
  scanning,
  stop,
}

extension BarcodeScanStatusExt on BarcodeScanStatus {
  bool get isScaning => this == BarcodeScanStatus.scanning;
}

class BarcodeController extends ValueNotifier<BarcodeScanStatus> {
  BarcodeController({
    bool autoStart = true,
  }) : super(autoStart ? BarcodeScanStatus.scanning : BarcodeScanStatus.init);

  bool get isScanning => value == BarcodeScanStatus.scanning;

  void start() {
    value = BarcodeScanStatus.scanning;
  }

  void stop() {
    value = BarcodeScanStatus.stop;
  }
}
