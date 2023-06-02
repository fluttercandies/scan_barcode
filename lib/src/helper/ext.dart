import 'package:flutter/services.dart';
import 'package:scan_barcode/scan_barcode.dart';

extension CameraControllerExt on CameraController {
  Size? get size {
    final src = value.previewSize;
    if (src == null) return null;
    if (isLandscape()) {
      return Size(src.width.toDouble(), src.height.toDouble());
    } else {
      return Size(src.height.toDouble(), src.width.toDouble());
    }
  }

  bool isLandscape() {
    return <DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ].contains(_getApplicableOrientation());
  }

  int getQuarterTurns() {
    final Map<DeviceOrientation, int> turns = <DeviceOrientation, int>{
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeRight: 1,
      DeviceOrientation.portraitDown: 2,
      DeviceOrientation.landscapeLeft: 3,
    };
    return turns[_getApplicableOrientation()]!;
  }

  DeviceOrientation _getApplicableOrientation() {
    return value.isRecordingVideo
        ? value.recordingOrientation!
        : (value.previewPauseOrientation ??
            value.lockedCaptureOrientation ??
            value.deviceOrientation);
  }
}

extension InputImageExt on InputImageMetadata {
  Size get fixedSize {
    if (rotation.rawValue == 90 || rotation.rawValue == 270) {
      return Size(size.height, size.width);
    } else {
      return size;
    }
  }
}
