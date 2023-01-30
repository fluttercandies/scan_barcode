import 'package:qr_camera/qr_camera.dart';

typedef OnHandleBarcodeList = Future<void> Function(List<Barcode> barCode);

typedef CameraControllerCreator = Future<CameraController?> Function(
  CameraConfig config,
);

typedef OnCameraControllerCreate = void Function(
  CameraController controller,
);