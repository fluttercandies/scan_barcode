# scan_barcode

The plugin is a plugin for scanning barcodes. Only support android and ios. Because the plugin is based on Google mlkit.

## Getting Started

```yaml
dependencies:
  scan_barcode: ^0.1.0
```

```yaml
scan_barcode:
  git:
    url: https://github.com/FlutterCandies/scan_barcode.git
    ref: git-ref
```

```yaml
scan_barcode:
  git:
    url: https://gitee.com/kikt/scan_barcode.git
    ref: git-ref
```

See the package [scan_barcode](https://pub.dev/packages/scan_barcode) for more version.

`import 'package:scan_barcode/scan_barcode.dart';`

The plugin is developed by version 3.1.0 of flutter, so it is recommended to use version 3.1.0 or above.
If you want to use the package of Flutter 2.x, click [here](#using-in-flutter-2x).

## Contents

The package has the following important classes:

- [BarcodeWidget](#barcodewidget)
- [BarcodeConfig](#barcodeconfig)

### BarcodeWidget

In most cases, we will use this component to complete code scanning.

### BarcodeConfig

This class is used to configure the scanning config. And, hold instance to update config.

The config has the following parts:

- CameraConfig: The camera config.
- BarcodeConfig: The barcode config.
- UIConfig: The UI config.

## Example

See the [example](./example/lib/examples) for more examples.

### One shot scan code

If you want to scan a code once, you can use the example.

<details>

<summary>Click to expand code</summary>

```dart
Future<void> _scanBarcode() async {
  final barcodes = await Navigator.push<List<Barcode>>(
    context,
    MaterialPageRoute(
      builder: (context) => const ScanAndPopPageExample(),
    ),
  );
  if (barcodes == null) return;
  showBarcodeListDialog(context, barcodes); // show barcode list dialog to display barcode.
}
```

```dart
import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

class ScanAndPopPageExample extends StatefulWidget {
  const ScanAndPopPageExample({Key? key}) : super(key: key);

  @override
  State<ScanAndPopPageExample> createState() => _ScanAndPopPageExampleState();
}

class _ScanAndPopPageExampleState extends State<ScanAndPopPageExample> {
  var isPop = false;

  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      onHandleBarcodeList: (List<Barcode> barcode) async {
        if (isPop) { // Prevent multiple pop
          return;
        }
        if (barcode.isEmpty) return;
        isPop = true;
        Navigator.of(context).pop(barcode);
      },
      scanValue: ScanValue(),
    );
  }
}

```

</details>

### Scan and show dialog in current page

<details>

<summary>Click to expand code</summary>

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
        await showBarcodeListDialog(
            context, barCode); // The await is important, if you don't await, multiple dialogs will be shown.
      },
    );
  }

  Future<void> showBarcodeListDialog(BuildContext context, List<Barcode> barCode) async {
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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

</details>

### Examples

- [How to change config](example/lib/examples/change_camera_config_example.dart)
- [How to custom barcode rect](example/lib/examples/change_qrcode_rect.dart)
- [One shot scan](example/lib/examples/scan_and_pop_page_example.dart)
- [Show the barcode list dialog when scanned](example/lib/examples/show_dialog_example.dart)

## dependencies

- [flutter](https://github.com/flutter/flutter)
- [camera](https://pub.dev/packages/camera)
- [google_mlkit_barcode_scanning](https://pub.dev/packages/google_mlkit_barcode_scanning)

## Common

### Using in flutter 2.x

The dependency `google_mlkit_barcode_scanning` is not support flutter 2.x.x, so need use forked version.

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
