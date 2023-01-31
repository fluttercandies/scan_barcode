import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

class ChangeQrcodeRectExample extends StatefulWidget {
  const ChangeQrcodeRectExample({Key? key}) : super(key: key);

  @override
  State<ChangeQrcodeRectExample> createState() =>
      _ChangeQrcodeRectExampleState();
}

class _ChangeQrcodeRectExampleState extends State<ChangeQrcodeRectExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Qrcode Rect style'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BarcodeWidget(
              scanValue: ScanValue(
                uiConfig: UIConfig(
                  barcodeRectItemBuilder: _buildBarcodeRectItem,
                ),
              ),
              onHandleBarcodeList: (List<Barcode> barCode) {
                return Future.value();
              },
            ),
          ),
        ],
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
