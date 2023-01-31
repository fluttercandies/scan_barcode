import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

class ChangeCameraConfigExample extends StatefulWidget {
  const ChangeCameraConfigExample({Key? key}) : super(key: key);

  @override
  State<ChangeCameraConfigExample> createState() =>
      _ChangeCameraConfigExampleState();
}

class _ChangeCameraConfigExampleState extends State<ChangeCameraConfigExample> {
  final scanValue = ScanValue();

  CameraController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Camera Config Example'),
      ),
      body: Column(
        children: [
          _buildBarcodeWidget(context),
          Expanded(
            child: options(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeWidget(BuildContext context) {
    return BarcodeWidget(
      onHandleBarcodeList: onHandleBarcodeList,
      scanValue: scanValue,
      onCameraControllerCreate: (controller) {
        this.controller = controller;
      },
    );
  }

  Widget options() {
    return Row(
      children: [
        _buildFlash(),
        _buildCamera(),
      ].map((e) => Expanded(child: e)).toList(),
    );
  }

  var flashOn = false;

  Widget _buildFlash() {
    final icon = flashOn ? Icons.flash_on : Icons.flash_off;
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        if (controller == null) {
          log('controller is null, please wait');
          return;
        }
        setState(() {
          flashOn = !flashOn;
        });
        controller!.setFlashMode(flashOn ? FlashMode.torch : FlashMode.off);
      },
    );
  }

  var backCamera = true;

  Widget _buildCamera() {
    final icon = backCamera ? Icons.camera_front : Icons.camera_rear;
    return IconButton(
      icon: Icon(icon),
      onPressed: () async{
        if (controller == null) {
          log('controller is null, please wait');
          return;
        }

        setState(() {
          backCamera = !backCamera;
        });

        final cameras = await availableCameras();
        final camera = cameras.firstWhere((element) => element.lensDirection == (backCamera ? CameraLensDirection.back : CameraLensDirection.front));

        final oldConfig = scanValue.cameraConfig;
        final newConfig = oldConfig.copyWith(
          camera: camera,
        );
        scanValue.updateCameraConfig(newConfig);
      },
    );
  }

  Future<void> onHandleBarcodeList(List<Barcode> barCode) async {
    if(barCode.isEmpty) {
      return;
    }
    log(barCode.map((e) => e.rawValue).join('\n'));
    await Future.delayed(const Duration(seconds: 3));
  }

}

