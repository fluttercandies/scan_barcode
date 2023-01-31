# scan_barcode

The plugin is a plugin for scanning barcodes. Only support android and ios. Because the plugin is based on mlkit.

## Getting Started

```yaml
dependencies:
  scan_barcode: ^0.1.0
```

See the package [scan_barcode](https://pub.dev/packages/scan_barcode) for more version.

`import 'package:scan_barcode/scan_barcode.dart';`

The plugin is developed by version 3.1.0 of flutter.

## Example

See the [example](./example/lib/examples) for more examples.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_barcode/scan_barcode.dart';

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
        await showBarcodeListDialog(context, barCode); // The await is important, if you don't await, multiple dialogs will be shown.
      },
    );
  }

  Future<void> showBarcodeListDialog(
      BuildContext context, List<Barcode> barCode) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Barcode list'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final barcode in barCode)
              ListTile(
                title: Text(barcode.rawValue ?? ''),
                subtitle:
                    Text('type: ${barcode.type}, format: ${barcode.format}'),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: barcode.rawValue ?? ''),
                    );
                  },
                ),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
```

## dependencies

- [flutter](https://github.com/flutter/flutter)
- [camera](https://pub.dev/packages/camera)
- [google_mlkit_barcode_scanning](https://pub.dev/packages/google_mlkit_barcode_scanning)

## For Flutter 2.x.x

The `google_mlkit_barcode_scanning` is not support flutter 2.x.x, so you need to use the fork version.

add the following to your `pubspec.yaml`:

```yaml
dependency_overrides:
  google_mlkit_barcode_scanning:
    git:
      url: https://gitee.com/kikt/Google-Ml-Kit-plugin.git
      ref: barcode-0.5.0-forked
      path: packages/google_mlkit_barcode_scanning
```

## LICENSE

Apache License 2.0
