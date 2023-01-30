import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    Key? key,
    required this.onImageCaptured,
    required this.config,
  }) : super(key: key);

  final Function(CameraDescription camera, CameraImage image) onImageCaptured;
  final ScanConfig config;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _controller;

  CameraController get controller => _controller!;

  late CameraDescription camera;

  bool noCamera = false;

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      setState(() {
        noCamera = true;
      });
      return;
    }

    camera = cameras.first;

    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        this.camera = camera;
        break;
      }
    }

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller.initialize();

    await controller.startImageStream((image) {
      widget.onImageCaptured(camera, image);
    });

    setState(() {
      isInit = true;
    });
  }

  var isInit = false;

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
    await controller.stopImageStream();
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInit) {
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
