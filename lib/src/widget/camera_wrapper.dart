import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:qr_camera/src/helper/qr_handler.dart';

import 'camera_widget.dart';

class QRWidget extends StatefulWidget {
  const QRWidget({
    Key? key,
    required this.onHandleBarcodeList,
  }) : super(key: key);

  final Future<void> Function(List<Barcode>) onHandleBarcodeList;

  @override
  State<QRWidget> createState() => _QRWidgetState();
}

class _QRWidgetState extends State<QRWidget> {
  final handler = QrcodeHandler();

  @override
  Widget build(BuildContext context) {
    return CameraWidget(
      onImageCaptured: (camera, CameraImage image) {
        handler.handleCameraImage(
          camera,
          image,
          (list) async {
            await widget.onHandleBarcodeList(list);
          },
        );
      },
    );
  }
}
