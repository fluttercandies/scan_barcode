import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

class BarcodeWidget extends StatefulWidget {
  const BarcodeWidget({
    Key? key,
    required this.onHandleBarcodeList,
    required this.scanValue,
    this.onCameraControllerCreate,
  }) : super(key: key);

  final OnHandleBarcodeList onHandleBarcodeList;
  final ScanValue scanValue;
  final OnCameraControllerCreate? onCameraControllerCreate;

  @override
  State<BarcodeWidget> createState() => _BarcodeWidgetState();
}

class _BarcodeWidgetState extends State<BarcodeWidget> {
  late var handler = BarcodeHandler(
    formats: widget.scanValue.barcodeConfig.formats,
  );

  final ValueNotifier<BarcodeData?> barcodeData = ValueNotifier(null);

  var callerIsHandle = false;

  @override
  void initState() {
    super.initState();
    widget.scanValue.addListener(onChange);
  }

  @override
  void dispose() {
    widget.scanValue.removeListener(onChange);
    super.dispose();
  }

  void onChange() {
    handler = BarcodeHandler(
      formats: widget.scanValue.barcodeConfig.formats,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BarcodeData?>(
      valueListenable: barcodeData,
      builder: (BuildContext context, BarcodeData? data, Widget? child) {
        return CameraImageWidget(
          onImageCaptured: (CameraDescription camera, CameraImage image) async {
            await handler.handleCameraImage(
              camera,
              image,
              (data) async {
                barcodeData.value = data;
                _callHandle(data);
              },
            );
          },
          config: widget.scanValue.cameraConfig,
          onCameraControllerCreate: (CameraController controller) {
            widget.onCameraControllerCreate?.call(controller);
          },
          child: BarcodeRectWidget(
            barcodeData: data,
            uiConfig: widget.scanValue.uiConfig,
          ),
        );
      },
    );
  }

  Future<void> _callHandle(BarcodeData data) async {
    if (callerIsHandle) return;
    callerIsHandle = true;
    await widget.onHandleBarcodeList(data.barcodeList);
    callerIsHandle = false;
  }
}
