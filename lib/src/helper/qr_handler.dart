import 'package:qr_camera/qr_camera.dart';

import 'package:flutter/foundation.dart';

import 'logger.dart';

class QrcodeHandler {
  // late final List<BarcodeFormat> formats = [BarcodeFormat.all];
  late final List<BarcodeFormat> formats = [BarcodeFormat.qrCode];
  late final barcodeScanner = BarcodeScanner(formats: formats);

  /// 处理相机图像中
  var _isProcessing = false;

  Future<void> handleCameraImage(
    CameraDescription camera,
    CameraImage cameraImage,
    Future<void> Function(List<Barcode>) onHandleBarcodeList,
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
        log('识别到二维码: ${barcodeList.length}');
        await onHandleBarcodeList(barcodeList);
      } catch (e) {
        log('onHandleBarcodeList error: $e');
      }
    }

    _isProcessing = false;
  }

  /// 处理二维码中
  var _scannerProcessing = false;

  Future<List<Barcode>> handleInputImage(InputImage image) async {
    if (_scannerProcessing) {
      return [];
    }

    _scannerProcessing = true;

    final barcodeList = await barcodeScanner.processImage(image);

    // print('barcodeList: ${barcodeList.length}');

    for (final barcode in barcodeList) {
      final bounds = barcode.boundingBox;
      final corners = barcode.cornerPoints;
      final rawValue = barcode.rawValue;
      log('bounds: $bounds');
      log('corners: $corners');
      log('rawValue: $rawValue');
    }

    _scannerProcessing = false;

    return barcodeList;
  }

  Future<void> close() async {
    await barcodeScanner.close();
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

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  }
}
