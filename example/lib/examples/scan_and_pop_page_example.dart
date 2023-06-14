import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

import 'full_screen_container.dart';

class ScanAndPopPageExample extends StatefulWidget {
  const ScanAndPopPageExample({Key? key}) : super(key: key);

  @override
  State<ScanAndPopPageExample> createState() => _ScanAndPopPageExampleState();
}

class _ScanAndPopPageExampleState extends State<ScanAndPopPageExample> {
  var isPop = false;

  @override
  Widget build(BuildContext context) {
    return FullScreenWidthBox(
      child: BarcodeWidget(
        onHandleBarcodeList: (List<Barcode> barcode) async {
          if (isPop) {
            // Prevent multiple pop
            return;
          }
          if (barcode.isEmpty) return;
          isPop = true;
          Navigator.of(context).pop(barcode);
        },
        scanValue: ScanValue(
          cameraConfig: const CameraConfig(
            preset: ResolutionPreset.max,
          ),
        ),
      ),
    );
  }
}
