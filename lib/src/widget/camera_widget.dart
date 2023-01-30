import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    Key? key,
    required this.onImageCaptured,
    required this.config,
    required this.onCameraControllerCreate,
  }) : super(key: key);

  final Function(CameraDescription camera, CameraImage image) onImageCaptured;
  final CameraConfig config;
  final OnCameraControllerCreate onCameraControllerCreate;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
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
      await controller?.initialize();
      if (controller != null) {
        widget.onCameraControllerCreate(controller!);
      }
    } catch (e) {
      setState(() {});
      return;
    }

    controller?.startImageStream((image) async {
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
  void didUpdateWidget(covariant CameraWidget oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: GestureDetector(
        onTapDown: (details) async {
          // click to auto focus
          await controller.setFocusMode(FocusMode.locked);
          await controller.setFocusMode(FocusMode.auto);
        },
        child: CameraPreview(
          controller,
        ),
      ),
    );
  }
}
