import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

class CameraImageWidget extends StatefulWidget {
  const CameraImageWidget({
    Key? key,
    required this.onImageCaptured,
    required this.config,
    required this.onCameraControllerCreate,
    this.child,
  }) : super(key: key);

  final Function(CameraDescription camera, CameraImage image) onImageCaptured;
  final CameraConfig config;
  final OnCameraControllerCreate onCameraControllerCreate;
  final Widget? child;

  @override
  State<CameraImageWidget> createState() => _CameraImageWidgetState();
}

class _CameraImageWidgetState extends State<CameraImageWidget> {
  CameraConfig get config => widget.config;

  CameraController? controller;

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

    cameraController.startImageStream((image) async {
      if (controller == null) return;
      final camera = controller!.description;
      await widget.onImageCaptured(camera, image);
    });
    setState(() {});
  }

  Future<void> recreateCamera() async {
    if (controller != null) {
      controller?.stopImageStream();
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
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await controller?.stopImageStream();
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
