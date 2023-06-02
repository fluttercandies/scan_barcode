import 'package:scan_barcode/scan_barcode.dart';

import 'package:flutter/foundation.dart';

import 'logger.dart';

class BarcodeData {
  final List<Barcode> barcodeList;
  final InputImage image;

  BarcodeData(this.barcodeList, this.image);
}

class BarcodeHandler {
  List<BarcodeFormat> formats;

  BarcodeScanner get barcodeScanner => BarcodeScanner(formats: formats);

  BarcodeHandler({
    this.formats = const [BarcodeFormat.qrCode],
  });

  void changeFormats(List<BarcodeFormat> formats) {
    this.formats = formats;
  }

  /// 处理相机图像中
  var _isProcessing = false;

  Future<void> handleCameraImage(
    CameraDescription camera,
    CameraImage cameraImage,
    Future<void> Function(BarcodeData barcodeData) onHandleBarcode,
  ) async {
    // print('handle image: ${cameraImage.width}x${cameraImage.height}');

    if (_isProcessing) {
      return;
    }

    _isProcessing = true;
    late InputImage inputImage;
    try {
      final image = _convertImage(camera, cameraImage);
      if (image == null) {
        _isProcessing = false;
        return;
      }
      inputImage = image;
    } catch (e) {
      log('convert image error: $e');
      _isProcessing = false;
      return;
    }

    final barcodeList = await handleInputImage(inputImage);
    if (barcodeList.isNotEmpty) {
      try {
        log('camera image found barcode: ${barcodeList.length}');
        await onHandleBarcode(BarcodeData(barcodeList, inputImage));
      } catch (e) {
        log('onHandleBarcodeList error: $e');
      }
    } else {
      log('camera image not found barcode');
      await onHandleBarcode(BarcodeData(barcodeList, inputImage));
    }

    _isProcessing = false;
  }

  /// 处理二维码中
  var _scannerProcessing = false;

  Future<List<Barcode>> handleInputImage(InputImage image) async {
    final scanner = barcodeScanner;
    try {
      if (_scannerProcessing) {
        return [];
      }
      _scannerProcessing = true;

      try {
        final barcodeList = await scanner.processImage(image);

        if (kDebugMode) {
          for (final barcode in barcodeList) {
            final bounds = barcode.boundingBox;
            final corners = barcode.cornerPoints;
            final rawValue = barcode.rawValue;
            log('bounds: $bounds');
            log('corners: $corners');
            log('rawValue: $rawValue');
          }
        }

        return barcodeList;
      } catch (e) {
        log('handleInputImage error: $e');
        return [];
      }
    } finally {
      scanner.close();
      _scannerProcessing = false;
    }
  }

  InputImage? _convertImage(CameraDescription camera, CameraImage cameraImage) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

    final InputImageRotation? imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);

    final InputImageFormat? inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage.format.raw);

    if (imageRotation == null || inputImageFormat == null) {
      return null;
    }

    final metadata = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: cameraImage.planes[0].bytesPerRow,
      // inputImageFormat: inputImageFormat,
      // planeData: planeData,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }
}
