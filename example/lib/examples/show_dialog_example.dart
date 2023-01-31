import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

import 'barcode_list_dialog.dart';

class ShowDialogExample extends StatelessWidget {
  const ShowDialogExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarcodeScanPage(
      title: 'Show dialog when scanned',
      onHandleBarcodeList: (List<Barcode> barCode) async {
        if (barCode.isEmpty) return;
        await showBarcodeListDialog(
          context,
          barCode,
        ); // The await is important, if you don't await, multiple dialogs will be shown.
      },
    );
  }
}
