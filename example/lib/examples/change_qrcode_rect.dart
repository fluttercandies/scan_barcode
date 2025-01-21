import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

class CustomBarcodeOverlayExample extends StatefulWidget {
  const CustomBarcodeOverlayExample({Key? key}) : super(key: key);

  @override
  State<CustomBarcodeOverlayExample> createState() =>
      _CustomBarcodeOverlayExampleState();
}

class _CustomBarcodeOverlayExampleState
    extends State<CustomBarcodeOverlayExample> {
  final controller = BarcodeController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Qrcode Rect style'),
      ),
      body: BarcodeWidget(
        controller: controller,
        scanValue: ScanValue(
          uiConfig: UIConfig(
            barcodeOverlayBuilder: _buildBarcodeRectItem,
          ),
          barcodeConfig: const BarcodeConfig(
            formats: [
              BarcodeFormat.all,
            ],
          ),
        ),
        onHandleBarcodeList: (List<Barcode> barCode) {
          return Future.value();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.isScanning) {
            controller.stop();
          } else {
            controller.start();
          }
        },
        child: ValueListenableBuilder<BarcodeScanStatus>(
          valueListenable: controller,
          builder: (context, status, child) {
            return Icon(
              status.isScaning ? Icons.pause : Icons.play_arrow_rounded,
            );
          },
        ),
      ),
    );
  }

  Widget _buildBarcodeRectItem(
    BuildContext context,
    Barcode barcode, {
    BarcodeController? controller,
  }) {
    return GestureDetector(
      onTap: () async {
        controller?.stop();
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(barcode.rawValue ?? ''),
          ),
        );
        controller?.start();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.yellow,
            width: 2,
          ),
          color: Colors.black38,
        ),
        alignment: Alignment.center,
        child: const Text(
          'Click me',
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
