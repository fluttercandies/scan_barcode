import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

enum _BarcodeStatus {
  init,
  scanning,
  stop,
}

class BarcodeController extends ValueNotifier<bool> {
  BarcodeController({bool autoStart = true})
      : _status = autoStart ? _BarcodeStatus.scanning : _BarcodeStatus.init,
        super(false);

  _BarcodeStatus _status;

  bool get isScanning => _status == _BarcodeStatus.scanning;

  void start() {
    _status = _BarcodeStatus.scanning;
    value = isScanning;
  }

  void stop() {
    _status = _BarcodeStatus.stop;
    value = isScanning;
  }
}

class BarcodeWidget extends StatefulWidget {
  const BarcodeWidget({
    Key? key,
    required this.onHandleBarcodeList,
    required this.scanValue,
    this.controller,
    this.onCameraControllerCreate,
    this.autoStop = false,
  }) : super(key: key);

  final OnHandleBarcodeList onHandleBarcodeList;
  final ScanValue scanValue;
  final OnCameraControllerCreate? onCameraControllerCreate;
  final BarcodeController? controller;
  final bool autoStop;

  @override
  State<BarcodeWidget> createState() => _BarcodeWidgetState();
}

class _BarcodeWidgetState extends State<BarcodeWidget> {
  late var handler = BarcodeHandler(
    formats: widget.scanValue.barcodeConfig.formats,
  );

  final ValueNotifier<BarcodeData?> barcodeData = ValueNotifier(null);
  late BarcodeController controller = widget.controller ?? BarcodeController();

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

  @override
  void didUpdateWidget(covariant BarcodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null) {
      controller = widget.controller!;
      setState(() {});
    }
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
            if (!controller.isScanning) return;
            return await handler.handleCameraImage(
              camera,
              image,
              (data) async {
                if (data.barcodeList.isEmpty) return;
                if (controller.isScanning && widget.autoStop) {
                  controller.stop();
                }
                barcodeData.value = data;
                _callHandle(data);
              },
            );
          },
          controller: controller,
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
