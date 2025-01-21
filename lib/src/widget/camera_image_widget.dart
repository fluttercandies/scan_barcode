import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

class CameraImageWidget extends StatefulWidget {
  const CameraImageWidget({
    Key? key,
    required this.onImageCaptured,
    required this.config,
    required this.onCameraControllerCreate,
    required this.controller,
    this.child,
  }) : super(key: key);

  final Function(CameraDescription camera, CameraImage image) onImageCaptured;
  final CameraConfig config;
  final OnCameraControllerCreate onCameraControllerCreate;
  final BarcodeController controller;
  final Widget? child;

  @override
  State<CameraImageWidget> createState() => _CameraImageWidgetState();
}

class _CameraImageWidgetState extends State<CameraImageWidget> {
  CameraConfig get config => widget.config;

  CameraController? controller;

  bool _isStarted = false;

  void onStatusChanged() {
    if (widget.controller.isScanning) {
      _start();
    } else {
      _stop();
    }
  }

  Future<void> _initCamera() async {
    final cameraController =
        await config.cameraControllerCreator(widget.config);
    if (cameraController == null) {
      setState(() {});
      return;
    }

    controller = cameraController;
    try {
      await cameraController.initialize();
      final size = cameraController.size;
      if (size != null) {
        aspectRatio = size.aspectRatio;
      }

      if (controller != null) {
        widget.onCameraControllerCreate(cameraController);
      }
    } catch (e) {
      setState(() {});
      return;
    }

    if (widget.controller.isScanning) {
      _start();
    }

    setState(() {});
  }

  void _start() {
    if (_isStarted) return;
    controller?.startImageStream((image) async {
      if (!widget.controller.isScanning) return;
      final camera = controller!.description;
      await widget.onImageCaptured(camera, image);
    });

    _isStarted = controller != null;
  }

  void _stop() {
    if (_isStarted) {
      controller?.stopImageStream();
      _isStarted = false;
    }
  }

  Future<void> recreateCamera() async {
    if (controller != null) {
      if (widget.controller.isScanning) {
        _stop();
      }
      controller?.dispose();
      controller = null;
    }
    await _initCamera();
  }

  @override
  void didUpdateWidget(covariant CameraImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      recreateCamera();
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(onStatusChanged);
      widget.controller.addListener(onStatusChanged);
    }
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
    widget.controller.addListener(onStatusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onStatusChanged);
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    if (_isStarted) {
      await controller?.stopImageStream();
    }
    await controller?.dispose();
  }

  var aspectRatio = 720 / 1280;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: GestureDetector(
        onTapDown: (details) async {
          // click to auto focus
          await controller.setFocusMode(FocusMode.locked);
          await controller.setFocusMode(FocusMode.auto);
        },
        child: CameraPreview(
          controller,
          child: widget.child,
        ),
      ),
    );
  }
}
