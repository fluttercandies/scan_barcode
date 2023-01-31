import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

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
  final handler = QrcodeHandler();

  final ValueNotifier<BarcodeData?> barcodeData = ValueNotifier(null);

  var callerIsHandle = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BarcodeData?>(
      valueListenable: barcodeData,
      builder: (BuildContext context, BarcodeData? data, Widget? child) {
        return CameraWidget(
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
          child: IgnorePointer(
            child: QrcodePointWidget(
              barcodeData: data,
              scanValue: widget.scanValue,
            ),
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

class QrcodePointWidget extends StatefulWidget {
  const QrcodePointWidget({
    Key? key,
    required this.scanValue,
    required this.barcodeData,
  }) : super(key: key);

  final BarcodeData? barcodeData;
  final ScanValue scanValue;

  @override
  State<QrcodePointWidget> createState() => _QrcodePointWidgetState();
}

class _QrcodePointWidgetState extends State<QrcodePointWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var data = widget.barcodeData;
        if (data == null) return Container();
        final imageSize = data.image.inputImageData?.fixedSize;
        if (imageSize == null) return Container();
        final barcodeList = data.barcodeList;
        if (barcodeList.isEmpty) return Container();

        final width = imageSize.width;
        final height = imageSize.height;

        final scaleX = constraints.maxWidth / width;
        final scaleY = constraints.maxHeight / height;

        return Stack(
          children: [
            ...barcodeList
                .map((barcode) => _buildBarcode(
                      barcode,
                      scaleX,
                      scaleY,
                    ))
                .whereType<Widget>()
          ],
        );
      },
    );
  }

  Widget? _buildBarcode(Barcode barcode, double scaleX, double scaleY) {
    final rect = barcode.boundingBox;

    if (rect == null) return null;

    final left = rect.left * scaleX;
    final top = rect.top * scaleY;
    final width = rect.width * scaleX;
    final height = rect.height * scaleY;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}
