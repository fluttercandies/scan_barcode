import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

class BarcodeWidget extends StatefulWidget {
  const BarcodeWidget({
    Key? key,
    required this.onHandleBarcodeList,
    required this.config,
  }) : super(key: key);

  final OnHandleBarcodeList onHandleBarcodeList;
  final ScanConfig config;

  @override
  State<BarcodeWidget> createState() => _BarcodeWidgetState();
}

class _BarcodeWidgetState extends State<BarcodeWidget> {
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
      config: widget.config,
    );
  }
}
