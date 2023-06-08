import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

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
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            _buildBarcodeWidget(context),
            SizedBox(
              height: 56 + MediaQuery.of(context).padding.top,
              child: AppBar(
                title: const Text('Change Camera Config Example'),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: options(),
            ),
          ],
        ),
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
        _buildChangePresent(),
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
      onPressed: () async {
        if (controller == null) {
          log('controller is null, please wait');
          return;
        }

        setState(() {
          backCamera = !backCamera;
        });

        final cameras = await availableCameras();
        final camera = cameras.firstWhere((element) =>
            element.lensDirection ==
            (backCamera
                ? CameraLensDirection.back
                : CameraLensDirection.front));

        final oldConfig = scanValue.cameraConfig;
        final newConfig = oldConfig.copyWith(
          camera: camera,
        );
        scanValue.updateCameraConfig(newConfig);
      },
    );
  }

  ResolutionPreset present = ResolutionPreset.high;

  Widget _buildChangePresent() {
    return DropdownButton<ResolutionPreset>(
      items: ResolutionPreset.values.map(
        (e) {
          final text = e.toString().split('.').last;
          return DropdownMenuItem<ResolutionPreset>(
            child: Text(text),
            value: e,
          );
        },
      ).toList(),
      value: present,
      onChanged: (v) {
        if (controller == null) {
          log('controller is null, please wait');
          return;
        }
        setState(() {
          present = v!;
        });

        final oldConfig = scanValue.cameraConfig;
        final newConfig = oldConfig.copyWith(
          preset: present,
        );
        scanValue.updateCameraConfig(newConfig);
      },
    );
  }

  Future<void> onHandleBarcodeList(List<Barcode> barCode) async {
    if (barCode.isEmpty) {
      return;
    }
    log(barCode.map((e) => e.rawValue).join('\n'));
    await Future.delayed(const Duration(seconds: 3));
  }
}
