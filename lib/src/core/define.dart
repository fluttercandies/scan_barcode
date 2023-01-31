import 'package:scan_barcode/scan_barcode.dart';

typedef OnHandleBarcodeList = Future<void> Function(List<Barcode> barcode);

typedef CameraControllerCreator = Future<CameraController?> Function(
  CameraConfig config,
);

typedef OnCameraControllerCreate = void Function(
  CameraController controller,
);
