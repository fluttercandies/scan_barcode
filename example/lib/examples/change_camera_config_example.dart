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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '配置',
            onPressed: () {
              if (controller == null) {
                log('controller is null, please wait');
                return;
              }
              showDialog(context: context, builder: _buildSettingDialog);
            },
          ),
        ],
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
      children: [],
    );
  }

  Future<void> onHandleBarcodeList(List<Barcode> barCode) async {
    log(barCode.map((e) => e.rawValue).join('\n'));
    await Future.delayed(const Duration(seconds: 3));
  }

  Widget _buildSettingDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('设置'),
      content: SingleChildScrollView(
        child: _SettingDialog(
          scanValue: scanValue,
          controller: controller!,
        ),
      ),
      actions: [
        TextButton(
          child: const Text('关闭'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _SettingDialog extends StatefulWidget {
  const _SettingDialog({
    Key? key,
    required this.scanValue,
    required this.controller,
  }) : super(key: key);

  final ScanValue scanValue;
  final CameraController controller;

  @override
  State<_SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<_SettingDialog> {
  CameraController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        buildFlashMode(),
      ],
    );
  }

  FlashMode _flashMode = FlashMode.off;

  Widget buildFlashMode() {
    Widget _buildFlashButton(FlashMode flashMode) {
      return TextButton(
        onPressed: () async {
          await controller.setFlashMode(flashMode);
          setState(() {
            _flashMode = flashMode;
          });
        },
        child: Text(
          flashMode.toString(),
          style: TextStyle(
            color: _flashMode == flashMode ? Colors.blue : Colors.black,
          ),
        ),
      );
    }

    return Column(
      children: [
        const Text('Flash Mode:'),
        Wrap(
          children: [
            _buildFlashButton(FlashMode.always),
            _buildFlashButton(FlashMode.off),
            _buildFlashButton(FlashMode.auto),
            _buildFlashButton(FlashMode.torch),
          ],
        ),
      ],
    );
  }
}
