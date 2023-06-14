import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

class CustomBarcodeOverlayExample extends StatefulWidget {
  const CustomBarcodeOverlayExample({Key? key}) : super(key: key);

  @override
  State<CustomBarcodeOverlayExample> createState() =>
      _CustomBarcodeOverlayExampleState();
}

class _CustomBarcodeOverlayExampleState extends State<CustomBarcodeOverlayExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Qrcode Rect style'),
      ),
      body: BarcodeWidget(
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
    );
  }

  Widget _buildBarcodeRectItem(BuildContext context, Barcode barcode) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(barcode.rawValue ?? ''),
          ),
        );
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
