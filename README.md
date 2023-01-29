# qr_camera

The plugin is a plugin for scanning QR codes. Only support android and ios.

## Getting Started

```yaml
dependencies:
  qr_camera: ^0.1.0
```

See the package [qr_camera](https://pub.dev/packages/qr_camera) for more version.

`import 'package:qr_camera/qr_camera.dart';`

The plugin is developed by version 3.1.0 of flutter.

## Example

See the [example](./example) for a complete sample app using qr_camera.

```dart
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
      ref: 3b2cf6af2e26d51fb5b6e215ad95c3609100762b
      path: packages/google_mlkit_barcode_scanning
```

## LICENSE

Apache License 2.0
